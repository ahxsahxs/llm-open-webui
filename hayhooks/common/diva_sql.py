SQL_GET_MACHINE= """
WITH machine_tickets AS (
    -- Get all maintenance tickets for the machine
    SELECT 
        mt.id as ticket_id,
        mt.ticket_number,
        mt.opening_date,
        mt.damage_description,
        mt.cause,
        mt.measure_taken,
        mt.machine_id
    FROM maintenance_ticket mt
    WHERE mt.machine_id = 1  -- Replace with desired machine ID
),
ticket_spare_parts AS (
    -- Get spare parts used in each ticket
    SELECT 
        spm.maintenance_ticket_id,
        spm.spare_part_id,
        spm.quantity as parts_used,
        spm.movement_date,
        sp.designation as part_name,
        sp.manufacturer,
        sp.supplier
    FROM spare_part_movement spm
    JOIN spare_part sp ON spm.spare_part_id = sp.id
    WHERE spm.maintenance_ticket_id IN (
        SELECT id FROM maintenance_ticket WHERE machine_id = 1  -- Replace with desired machine ID
    )
),
plant_stock AS (
    -- Get current stock for all spare parts in the machine's plant
    SELECT 
        sps.spare_part_id,
        sps.current_stock,
        sps.unit_measure,
        sp.designation as part_name,
        sp.manufacturer,
        sp.supplier
    FROM spare_part_stock sps
    JOIN spare_part sp ON sps.spare_part_id = sp.id
    JOIN machine m ON sps.plant_name = m.plant_name
    WHERE m.id = 1  -- Replace with desired machine ID
)

-- Main query with tree structure using JSON aggregation (PostgreSQL 9.4+)
-- If your database doesn't support JSON functions, see alternative version below
SELECT 
    -- Machine Level (Root)
    m.id as machine_id,
    m.plant_name,
    m.designation as machine_designation,
    
    -- Maintenance Tickets Level
    json_agg(
        DISTINCT jsonb_build_object(
            'ticket_id', mt.ticket_id,
            'ticket_number', mt.ticket_number,
            'opening_date', mt.opening_date,
            'damage_description', mt.damage_description,
            'cause', mt.cause,
            'measure_taken', mt.measure_taken,
            'spare_parts_used', (
                SELECT json_agg(
                    jsonb_build_object(
                        'part_id', tsp.spare_part_id,
                        'part_name', tsp.part_name,
                        'manufacturer', tsp.manufacturer,
                        'supplier', tsp.supplier,
                        'quantity_used', tsp.parts_used,
                        'movement_date', tsp.movement_date,
                        'current_stock', (
                            SELECT json_agg(
                                jsonb_build_object(
                                    'plant_name', stock.plant_name,
                                    'current_stock', stock.current_stock,
                                    'unit_measure', stock.unit_measure
                                )
                            )
                            FROM spare_part_stock stock
                            WHERE stock.spare_part_id = tsp.spare_part_id
                        )
                    )
                )
                FROM ticket_spare_parts tsp 
                WHERE tsp.maintenance_ticket_id = mt.ticket_id
            )
        )
    ) FILTER (WHERE mt.ticket_id IS NOT NULL) as maintenance_tickets

FROM machine m
LEFT JOIN machine_tickets mt ON m.id = mt.machine_id
WHERE m.id = %(machine_id)s  -- Replace with desired machine ID
GROUP BY m.id, m.plant_name, m.designation;
"""