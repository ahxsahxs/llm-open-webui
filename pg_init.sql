-- Factory Maintenance Database Seed Script
-- Drop existing tables if they exist
DROP TABLE IF EXISTS spare_part_movement;
DROP TABLE IF EXISTS spare_part_stock;
DROP TABLE IF EXISTS maintenance_ticket;
DROP TABLE IF EXISTS spare_part;
DROP TABLE IF EXISTS machine;

-- Create tables
CREATE TABLE machine (
    id SERIAL PRIMARY KEY,
    plant_name VARCHAR(100) NOT NULL,
    designation VARCHAR(100) NOT NULL
);

CREATE TABLE maintenance_ticket (
    id SERIAL PRIMARY KEY,
    ticket_number VARCHAR(20) UNIQUE NOT NULL,
    machine_id INTEGER NOT NULL REFERENCES machine(id),
    opening_date DATE NOT NULL,
    damage_description TEXT NOT NULL,
    cause TEXT,
    measure_taken TEXT
);

CREATE TABLE spare_part (
    id SERIAL PRIMARY KEY,
    designation VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    supplier VARCHAR(100) NOT NULL
);

CREATE TABLE spare_part_movement (
    id SERIAL PRIMARY KEY,
    spare_part_id INTEGER NOT NULL REFERENCES spare_part(id),
    maintenance_ticket_id INTEGER NOT NULL REFERENCES maintenance_ticket(id),
    quantity INTEGER NOT NULL,
    movement_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE spare_part_stock (
    id SERIAL PRIMARY KEY,
    plant_name VARCHAR(100) NOT NULL,
    spare_part_id INTEGER NOT NULL REFERENCES spare_part(id),
    unit_measure VARCHAR(20) NOT NULL,
    current_stock INTEGER NOT NULL DEFAULT 0,
    UNIQUE(plant_name, spare_part_id)
);

-- Insert Machines (20 machines across 3 plants)
INSERT INTO machine (plant_name, designation) VALUES
('Plant A', 'CNC Milling Machine #1'),
('Plant A', 'Hydraulic Press #1'),
('Plant A', 'Conveyor Belt System #1'),
('Plant A', 'Industrial Robot Arm #1'),
('Plant A', 'Packaging Machine #1'),
('Plant A', 'Quality Control Scanner #1'),
('Plant A', 'Air Compressor Unit #1'),
('Plant B', 'CNC Lathe Machine #2'),
('Plant B', 'Welding Station #1'),
('Plant B', 'Paint Booth System #1'),
('Plant B', 'Material Handling Crane #1'),
('Plant B', 'Injection Molding Machine #1'),
('Plant B', 'Assembly Line Motor #1'),
('Plant B', 'Cooling System Unit #1'),
('Plant C', 'Grinding Machine #1'),
('Plant C', 'Drilling Press #1'),
('Plant C', 'Furnace Control System #1'),
('Plant C', 'Ventilation Fan Unit #1'),
('Plant C', 'Electrical Panel Box #1'),
('Plant C', 'Water Pump System #1');

-- Insert Spare Parts (20 spare parts)
INSERT INTO spare_part (designation, manufacturer, supplier) VALUES
('Motor Bearing 6205', 'SKF', 'Industrial Supply Co'),
('Hydraulic Seal Kit', 'Parker', 'Hydraulics Direct'),
('Conveyor Belt 1200mm', 'Continental', 'Belt Solutions Ltd'),
('Servo Motor Drive', 'Siemens', 'Automation Parts Inc'),
('Pneumatic Cylinder 50mm', 'Festo', 'Pneumatic World'),
('LED Warning Light', 'Schneider', 'Safety Equipment Co'),
('Gear Box Oil SAE 90', 'Shell', 'Lubricants Plus'),
('Temperature Sensor PT100', 'Omega', 'Sensor Technologies'),
('Relay Switch 24V', 'ABB', 'Electrical Components Ltd'),
('V-Belt A43', 'Gates', 'Power Transmission Co'),
('Ball Valve 1/2 inch', 'Swagelok', 'Valve Supply Center'),
('Air Filter Element', 'Mann Filter', 'Filter Solutions'),
('Coupling Flexible 25mm', 'KTR', 'Coupling Specialists'),
('Proximity Switch M12', 'Pepperl+Fuchs', 'Sensor Direct'),
('Chain Link 12B-1', 'Renold', 'Chain Supply Co'),
('Grease Nipple M6', 'Alemite', 'Lubrication Parts'),
('Pressure Gauge 0-10bar', 'Wika', 'Instrumentation Co'),
('Solenoid Valve 24VDC', 'Asco', 'Valve Automation Ltd'),
('Heat Exchanger Gasket', 'Krones', 'Sealing Solutions'),
('Emergency Stop Button', 'Pilz', 'Safety Systems Inc');

-- Insert Spare Part Stock (for each plant and spare part)
INSERT INTO spare_part_stock (plant_name, spare_part_id, unit_measure, current_stock) VALUES
-- Plant A Stock
('Plant A', 1, 'pieces', 15), ('Plant A', 2, 'kits', 8), ('Plant A', 3, 'pieces', 3),
('Plant A', 4, 'pieces', 5), ('Plant A', 5, 'pieces', 12), ('Plant A', 6, 'pieces', 20),
('Plant A', 7, 'liters', 50), ('Plant A', 8, 'pieces', 10), ('Plant A', 9, 'pieces', 25),
('Plant A', 10, 'pieces', 8), ('Plant A', 11, 'pieces', 6), ('Plant A', 12, 'pieces', 15),
('Plant A', 13, 'pieces', 4), ('Plant A', 14, 'pieces', 18), ('Plant A', 15, 'meters', 30),
('Plant A', 16, 'pieces', 50), ('Plant A', 17, 'pieces', 7), ('Plant A', 18, 'pieces', 9),
('Plant A', 19, 'pieces', 12), ('Plant A', 20, 'pieces', 22),
-- Plant B Stock
('Plant B', 1, 'pieces', 12), ('Plant B', 2, 'kits', 6), ('Plant B', 3, 'pieces', 2),
('Plant B', 4, 'pieces', 7), ('Plant B', 5, 'pieces', 10), ('Plant B', 6, 'pieces', 18),
('Plant B', 7, 'liters', 45), ('Plant B', 8, 'pieces', 8), ('Plant B', 9, 'pieces', 30),
('Plant B', 10, 'pieces', 6), ('Plant B', 11, 'pieces', 4), ('Plant B', 12, 'pieces', 12),
('Plant B', 13, 'pieces', 3), ('Plant B', 14, 'pieces', 15), ('Plant B', 15, 'meters', 25),
('Plant B', 16, 'pieces', 45), ('Plant B', 17, 'pieces', 5), ('Plant B', 18, 'pieces', 11),
('Plant B', 19, 'pieces', 8), ('Plant B', 20, 'pieces', 19),
-- Plant C Stock
('Plant C', 1, 'pieces', 18), ('Plant C', 2, 'kits', 10), ('Plant C', 3, 'pieces', 4),
('Plant C', 4, 'pieces', 6), ('Plant C', 5, 'pieces', 14), ('Plant C', 6, 'pieces', 25),
('Plant C', 7, 'liters', 40), ('Plant C', 8, 'pieces', 12), ('Plant C', 9, 'pieces', 28),
('Plant C', 10, 'pieces', 9), ('Plant C', 11, 'pieces', 5), ('Plant C', 12, 'pieces', 18),
('Plant C', 13, 'pieces', 6), ('Plant C', 14, 'pieces', 20), ('Plant C', 15, 'meters', 35),
('Plant C', 16, 'pieces', 60), ('Plant C', 17, 'pieces', 8), ('Plant C', 18, 'pieces', 13),
('Plant C', 19, 'pieces', 10), ('Plant C', 20, 'pieces', 24);

-- Insert Maintenance Tickets (5 tickets per machine = 100 tickets total)
INSERT INTO maintenance_ticket (ticket_number, machine_id, opening_date, damage_description, cause, measure_taken) VALUES
-- Machine 1 tickets
('MT-2024-001', 1, '2024-01-15', 'Excessive vibration during operation', 'Worn bearing in spindle motor', 'Replaced motor bearing and realigned spindle'),
('MT-2024-002', 1, '2024-02-20', 'CNC program errors and positioning issues', 'Servo drive malfunction', 'Replaced servo motor drive and recalibrated axes'),
('MT-2024-003', 1, '2024-03-10', 'Coolant system leak', 'Damaged hydraulic seal', 'Installed new hydraulic seal kit'),
('MT-2024-004', 1, '2024-04-05', 'Emergency stop activated unexpectedly', 'Faulty proximity switch', 'Replaced proximity switch M12'),
('MT-2024-005', 1, '2024-05-12', 'Overheating of gearbox', 'Low oil level', 'Refilled with gear box oil SAE 90'),

-- Machine 2 tickets
('MT-2024-006', 2, '2024-01-08', 'Hydraulic pressure drop', 'Worn hydraulic seals', 'Replaced hydraulic seal kit'),
('MT-2024-007', 2, '2024-02-14', 'Press not reaching full force', 'Air in hydraulic system', 'Bled hydraulic system and checked pressure gauge'),
('MT-2024-008', 2, '2024-03-22', 'Safety light not working', 'Burned out LED warning light', 'Replaced LED warning light'),
('MT-2024-009', 2, '2024-04-18', 'Unusual noise from pump', 'Worn coupling', 'Replaced flexible coupling 25mm'),
('MT-2024-010', 2, '2024-05-25', 'Overheating protection triggered', 'Blocked air filter', 'Replaced air filter element'),

-- Machine 3 tickets
('MT-2024-011', 3, '2024-01-12', 'Belt slipping under load', 'Stretched conveyor belt', 'Replaced conveyor belt 1200mm'),
('MT-2024-012', 3, '2024-02-08', 'Motor not starting', 'Faulty relay switch', 'Replaced relay switch 24V'),
('MT-2024-013', 3, '2024-03-15', 'Belt tracking issues', 'Worn V-belt', 'Replaced V-belt A43'),
('MT-2024-014', 3, '2024-04-12', 'Temperature sensor malfunction', 'Damaged PT100 sensor', 'Replaced temperature sensor PT100'),
('MT-2024-015', 3, '2024-05-20', 'Emergency stop button stuck', 'Worn button mechanism', 'Replaced emergency stop button'),

-- Machine 4 tickets
('MT-2024-016', 4, '2024-01-25', 'Robot arm positioning errors', 'Servo drive calibration drift', 'Replaced servo motor drive and recalibrated'),
('MT-2024-017', 4, '2024-02-28', 'Pneumatic gripper not closing', 'Faulty pneumatic cylinder', 'Replaced pneumatic cylinder 50mm'),
('MT-2024-018', 4, '2024-03-18', 'Safety sensors not responding', 'Dirty proximity switch', 'Cleaned and replaced proximity switch M12'),
('MT-2024-019', 4, '2024-04-22', 'Joint lubrication needed', 'Dry grease nipples', 'Added grease through grease nipple M6'),
('MT-2024-020', 4, '2024-05-30', 'Control valve not operating', 'Failed solenoid valve', 'Replaced solenoid valve 24VDC'),

-- Machine 5 tickets
('MT-2024-021', 5, '2024-01-30', 'Packaging material jammed', 'Worn chain links', 'Replaced chain link 12B-1'),
('MT-2024-022', 5, '2024-02-25', 'Temperature control issues', 'Faulty heat exchanger gasket', 'Replaced heat exchanger gasket'),
('MT-2024-023', 5, '2024-03-28', 'Pressure system failure', 'Blocked ball valve', 'Replaced ball valve 1/2 inch'),
('MT-2024-024', 5, '2024-04-30', 'Motor bearing noise', 'Worn motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-025', 5, '2024-06-05', 'Warning system malfunction', 'Faulty LED warning light', 'Replaced LED warning light'),

-- Continue with remaining machines (6-20) following same pattern...
-- Machine 6-10 tickets
('MT-2024-026', 6, '2024-01-18', 'Scanner calibration error', 'Damaged temperature sensor', 'Replaced temperature sensor PT100'),
('MT-2024-027', 6, '2024-02-22', 'Power supply issues', 'Faulty relay switch', 'Replaced relay switch 24V'),
('MT-2024-028', 6, '2024-03-25', 'Optical sensor dirty', 'Contaminated proximity switch', 'Cleaned and replaced proximity switch M12'),
('MT-2024-029', 6, '2024-04-28', 'Emergency stop test failed', 'Worn emergency stop button', 'Replaced emergency stop button'),
('MT-2024-030', 6, '2024-05-28', 'Cooling fan malfunction', 'Blocked air filter', 'Replaced air filter element'),

('MT-2024-031', 7, '2024-01-22', 'Pressure drop in system', 'Faulty pressure gauge', 'Replaced pressure gauge 0-10bar'),
('MT-2024-032', 7, '2024-02-26', 'Compressor overheating', 'Low oil level', 'Refilled with gear box oil SAE 90'),
('MT-2024-033', 7, '2024-03-30', 'Air leak in system', 'Damaged ball valve', 'Replaced ball valve 1/2 inch'),
('MT-2024-034', 7, '2024-05-02', 'Motor vibration', 'Worn motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-035', 7, '2024-06-08', 'Filter clogged', 'Dirty air filter element', 'Replaced air filter element'),

('MT-2024-036', 8, '2024-01-28', 'Spindle not rotating smoothly', 'Worn motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-037', 8, '2024-03-02', 'Drive system fault', 'Failed servo motor drive', 'Replaced servo motor drive'),
('MT-2024-038', 8, '2024-04-05', 'Coolant pump issues', 'Worn flexible coupling', 'Replaced coupling flexible 25mm'),
('MT-2024-039', 8, '2024-05-08', 'Temperature alarm', 'Faulty temperature sensor', 'Replaced temperature sensor PT100'),
('MT-2024-040', 8, '2024-06-12', 'Chuck not gripping', 'Hydraulic seal failure', 'Installed hydraulic seal kit'),

('MT-2024-041', 9, '2024-02-02', 'Welding arc unstable', 'Faulty relay switch', 'Replaced relay switch 24V'),
('MT-2024-042', 9, '2024-03-05', 'Gas flow irregular', 'Blocked solenoid valve', 'Replaced solenoid valve 24VDC'),
('MT-2024-043', 9, '2024-04-08', 'Safety sensors not working', 'Damaged proximity switch', 'Replaced proximity switch M12'),
('MT-2024-044', 9, '2024-05-15', 'Ventilation fan stopped', 'Motor bearing seized', 'Replaced motor bearing 6205'),
('MT-2024-045', 9, '2024-06-18', 'Emergency stop malfunction', 'Worn stop button', 'Replaced emergency stop button'),

('MT-2024-046', 10, '2024-02-05', 'Paint pressure inconsistent', 'Faulty pressure gauge', 'Replaced pressure gauge 0-10bar'),
('MT-2024-047', 10, '2024-03-08', 'Spray pattern irregular', 'Clogged ball valve', 'Replaced ball valve 1/2 inch'),
('MT-2024-048', 10, '2024-04-12', 'Temperature control failure', 'Bad temperature sensor', 'Replaced temperature sensor PT100'),
('MT-2024-049', 10, '2024-05-18', 'Air supply problems', 'Dirty air filter', 'Replaced air filter element'),
('MT-2024-050', 10, '2024-06-22', 'Booth lighting failed', 'Burned LED warning light', 'Replaced LED warning light'),

-- Machines 11-15 tickets
('MT-2024-051', 11, '2024-02-08', 'Crane movement jerky', 'Worn motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-052', 11, '2024-03-12', 'Hoist not lifting', 'Failed servo motor drive', 'Replaced servo motor drive'),
('MT-2024-053', 11, '2024-04-15', 'Safety brake issues', 'Hydraulic seal worn', 'Installed hydraulic seal kit'),
('MT-2024-054', 11, '2024-05-22', 'Control pendant fault', 'Faulty relay switch', 'Replaced relay switch 24V'),
('MT-2024-055', 11, '2024-06-25', 'Load sensor error', 'Damaged proximity switch', 'Replaced proximity switch M12'),

('MT-2024-056', 12, '2024-02-12', 'Injection pressure low', 'Worn hydraulic seals', 'Installed hydraulic seal kit'),
('MT-2024-057', 12, '2024-03-15', 'Mold not closing properly', 'Faulty pneumatic cylinder', 'Replaced pneumatic cylinder 50mm'),
('MT-2024-058', 12, '2024-04-18', 'Temperature fluctuation', 'Bad temperature sensor', 'Replaced temperature sensor PT100'),
('MT-2024-059', 12, '2024-05-25', 'Cooling system leak', 'Failed heat exchanger gasket', 'Replaced heat exchanger gasket'),
('MT-2024-060', 12, '2024-06-28', 'Emergency stop test failed', 'Worn emergency stop button', 'Replaced emergency stop button'),

('MT-2024-061', 13, '2024-02-15', 'Motor not starting', 'Blown relay switch', 'Replaced relay switch 24V'),
('MT-2024-062', 13, '2024-03-18', 'Belt drive slipping', 'Stretched V-belt', 'Replaced V-belt A43'),
('MT-2024-063', 13, '2024-04-22', 'Bearing noise', 'Worn motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-064', 13, '2024-05-28', 'Speed control issues', 'Faulty servo motor drive', 'Replaced servo motor drive'),
('MT-2024-065', 13, '2024-07-02', 'Lubrication system fault', 'Blocked grease nipple', 'Replaced grease nipple M6'),

('MT-2024-066', 14, '2024-02-18', 'Cooling efficiency reduced', 'Dirty air filter', 'Replaced air filter element'),
('MT-2024-067', 14, '2024-03-22', 'Pump cavitation', 'Faulty ball valve', 'Replaced ball valve 1/2 inch'),
('MT-2024-068', 14, '2024-04-25', 'Temperature sensor alarm', 'Failed temperature sensor', 'Replaced temperature sensor PT100'),
('MT-2024-069', 14, '2024-05-30', 'Pressure relief valve stuck', 'Worn solenoid valve', 'Replaced solenoid valve 24VDC'),
('MT-2024-070', 14, '2024-07-05', 'Heat exchanger leak', 'Damaged gasket', 'Replaced heat exchanger gasket'),

-- Machines 15-20 tickets  
('MT-2024-071', 15, '2024-02-22', 'Grinding wheel vibration', 'Worn motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-072', 15, '2024-03-25', 'Feed drive malfunction', 'Failed servo motor drive', 'Replaced servo motor drive'),
('MT-2024-073', 15, '2024-04-28', 'Coolant flow restricted', 'Clogged ball valve', 'Replaced ball valve 1/2 inch'),
('MT-2024-074', 15, '2024-06-02', 'Safety guard sensor fault', 'Dirty proximity switch', 'Replaced proximity switch M12'),
('MT-2024-075', 15, '2024-07-08', 'Emergency stop sticky', 'Worn stop button', 'Replaced emergency stop button'),

('MT-2024-076', 16, '2024-02-25', 'Drill bit not advancing', 'Hydraulic pressure loss', 'Installed hydraulic seal kit'),
('MT-2024-077', 16, '2024-03-28', 'Motor overload trips', 'Bad motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-078', 16, '2024-05-02', 'Depth sensor error', 'Faulty proximity switch', 'Replaced proximity switch M12'),
('MT-2024-079', 16, '2024-06-05', 'Control relay failure', 'Burned relay switch', 'Replaced relay switch 24V'),
('MT-2024-080', 16, '2024-07-12', 'Chuck lubrication needed', 'Dry grease nipples', 'Serviced grease nipple M6'),

('MT-2024-081', 17, '2024-03-02', 'Temperature not reaching setpoint', 'Faulty temperature sensor', 'Replaced temperature sensor PT100'),
('MT-2024-082', 17, '2024-04-05', 'Gas valve not opening', 'Failed solenoid valve', 'Replaced solenoid valve 24VDC'),
('MT-2024-083', 17, '2024-05-08', 'Safety interlock bypass', 'Damaged proximity switch', 'Replaced proximity switch M12'),
('MT-2024-084', 17, '2024-06-12', 'Combustion air fan stopped', 'Seized motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-085', 17, '2024-07-15', 'Emergency shutdown test failed', 'Faulty emergency stop button', 'Replaced emergency stop button'),

('MT-2024-086', 18, '2024-03-05', 'Fan not running at full speed', 'Worn V-belt drive', 'Replaced V-belt A43'),
('MT-2024-087', 18, '2024-04-08', 'Motor bearing noise', 'Worn motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-088', 18, '2024-05-12', 'Air flow sensor fault', 'Bad proximity switch', 'Replaced proximity switch M12'),
('MT-2024-089', 18, '2024-06-15', 'Control system malfunction', 'Failed relay switch', 'Replaced relay switch 24V'),
('MT-2024-090', 18, '2024-07-18', 'Filter replacement needed', 'Clogged air filter', 'Replaced air filter element'),

('MT-2024-091', 19, '2024-03-08', 'Panel door not closing', 'Worn door mechanism', 'Replaced coupling flexible 25mm'),
('MT-2024-092', 19, '2024-04-12', 'Warning lights not working', 'Failed LED warning light', 'Replaced LED warning light'),
('MT-2024-093', 19, '2024-05-15', 'Relay chattering', 'Worn relay contacts', 'Replaced relay switch 24V'),
('MT-2024-094', 19, '2024-06-18', 'Temperature monitoring fault', 'Bad temperature sensor', 'Replaced temperature sensor PT100'),
('MT-2024-095', 19, '2024-07-22', 'Emergency stop not latching', 'Worn emergency stop button', 'Replaced emergency stop button'),

('MT-2024-096', 20, '2024-03-12', 'Pump not priming', 'Air in suction line', 'Replaced ball valve 1/2 inch'),
('MT-2024-097', 20, '2024-04-15', 'Motor overheating', 'Worn motor bearing', 'Replaced motor bearing 6205'),
('MT-2024-098', 20, '2024-05-18', 'Pressure switch malfunction', 'Faulty pressure gauge', 'Replaced pressure gauge 0-10bar'),
('MT-2024-099', 20, '2024-06-22', 'Flow control valve stuck', 'Failed solenoid valve', 'Replaced solenoid valve 24VDC'),
('MT-2024-100', 20, '2024-07-25', 'System leak detected', 'Damaged hydraulic seals', 'Installed hydraulic seal kit');

-- Insert Spare Part Movements (random movements linking spare parts to maintenance tickets)
INSERT INTO spare_part_movement (spare_part_id, maintenance_ticket_id, quantity, movement_date) VALUES
-- Movements for first 25 tickets
(1, 1, 2, '2024-01-15'), (4, 2, 1, '2024-02-20'), (2, 3, 1, '2024-03-10'),
(14, 4, 1, '2024-04-05'), (7, 5, 5, '2024-05-12'), (2, 6, 1, '2024-01-08'),
(17, 7, 1, '2024-02-14'), (6, 8, 1, '2024-03-22'), (13, 9, 1, '2024-04-18'),
(12, 10, 1, '2024-05-25'), (3, 11, 1, '2024-01-12'), (9, 12, 1, '2024-02-08'),
(10, 13, 1, '2024-03-15'), (8, 14, 1, '2024-04-12'), (20, 15, 1, '2024-05-20'),
(4, 16, 1, '2024-01-25'), (5, 17, 1, '2024-02-28'), (14, 18, 1, '2024-03-18'),
(16, 19, 10, '2024-04-22'), (18, 20, 1, '2024-05-30'), (15, 21, 3, '2024-01-30'),
(19, 22, 1, '2024-02-25'), (11, 23, 1, '2024-03-28'), (1, 24, 1, '2024-04-30'),
(6, 25, 1, '2024-06-05'),

-- Movements for tickets 26-50
(8, 26, 1, '2024-01-18'), (9, 27, 1, '2024-02-22'), (14, 28, 1, '2024-03-25'),
(20, 29, 1, '2024-04-28'), (12, 30, 1, '2024-05-28'), (17, 31, 1, '2024-01-22'),
(7, 32, 8, '2024-02-26'), (11, 33, 1, '2024-03-30'), (1, 34, 1, '2024-05-02'),
(12, 35, 1, '2024-06-08'), (1, 36, 1, '2024-01-28'), (4, 37, 1, '2024-03-02'),
(13, 38, 1, '2024-04-05'), (8, 39, 1, '2024-05-08'), (2, 40, 1, '2024-06-12'),
(9, 41, 1, '2024-02-02'), (18, 42, 1, '2024-03-05'), (14, 43, 1, '2024-04-08'),
(1, 44, 1, '2024-05-15'), (20, 45, 1, '2024-06-18'), (17, 46, 1, '2024-02-05'),
(11, 47, 1, '2024-03-08'), (8, 48, 1, '2024-04-12'), (12, 49, 1, '2024-05-18'),
(6, 50, 1, '2024-06-22'),

-- Additional movements for remaining tickets (51-100)
(1, 51, 1, '2024-02-08'), (4, 52, 1, '2024-03-12'), (2, 53, 1, '2024-04-15'),
(9, 54, 1, '2024-05-22'), (14, 55, 1, '2024-06-25'), (2, 56, 1, '2024-02-12'),
(5, 57, 1, '2024-03-15'), (8, 58, 1, '2024-04-18'), (19, 59, 1, '2024-05-25'),
(20, 60, 1, '2024-06-28'), (9, 61, 1, '2024-02-15'), (10, 62, 1, '2024-03-18'),
(1, 63, 1, '2024-04-22'), (4, 64, 1, '2024-05-28'), (16, 65, 5, '2024-07-02'),
(12, 66, 1, '2024-02-18'), (11, 67, 1, '2024-03-22'), (8, 68, 1, '2024-04-25'),
(18, 69, 1, '2024-05-30'), (19, 70, 1, '2024-07-05'), (1, 71, 1, '2024-02-22'),
(4, 72, 1, '2024-03-25'), (11, 73, 1, '2024-04-28'), (14, 74, 1, '2024-06-02'),
(20, 75, 1, '2024-07-08'), (2, 76, 1, '2024-02-25'), (1, 77, 1, '2024-03-28'),
(14, 78, 1, '2024-05-02'), (9, 79, 1, '2024-06-05'), (16, 80, 3, '2024-07-12'),
(8, 81, 1, '2024-03-02'), (18, 82, 1, '2024-04-05'), (14, 83, 1, '2024-05-08'),
(1, 84, 1, '2024-06-12'), (20, 85, 1, '2024-07-15'), (10, 86, 1, '2024-03-05'),
(1, 87, 1, '2024-04-08'), (14, 88, 1, '2024-05-12'), (9, 89, 1, '2024-06-15'),
(12, 90, 1, '2024-07-18'), (13, 91, 1, '2024-03-08'), (6, 92, 1, '2024-04-12'),
(9, 93, 1, '2024-05-15'), (8, 94, 1, '2024-06-18'), (20, 95, 1, '2024-07-22'),
(11, 96, 1, '2024-03-12'), (1, 97, 1, '2024-04-15'), (17, 98, 1, '2024-05-18'),
(18, 99, 1, '2024-06-22'), (2, 100, 1, '2024-07-25');



-- Create indexes for better performance
CREATE INDEX idx_maintenance_ticket_machine_id ON maintenance_ticket(machine_id);
CREATE INDEX idx_maintenance_ticket_opening_date ON maintenance_ticket(opening_date);
CREATE INDEX idx_spare_part_movement_spare_part_id ON spare_part_movement(spare_part_id);
CREATE INDEX idx_spare_part_movement_maintenance_ticket_id ON spare_part_movement(maintenance_ticket_id);
CREATE INDEX idx_spare_part_stock_plant_spare_part ON spare_part_stock(plant_name, spare_part_id);

-- Sample queries to verify the data
-- View machines by plant
SELECT plant_name, COUNT(*) as machine_count FROM machine GROUP BY plant_name;

-- View maintenance tickets summary
SELECT 
    m.plant_name,
    COUNT(mt.id) as total_tickets,
    MIN(mt.opening_date) as earliest_ticket,
    MAX(mt.opening_date) as latest_ticket
FROM machine m
JOIN maintenance_ticket mt ON m.id = mt.machine_id
GROUP BY m.plant_name;

-- View spare parts usage
SELECT 
    sp.designation,
    sp.manufacturer,
    COUNT(spm.id) as times_used,
    SUM(spm.quantity) as total_quantity_used
FROM spare_part sp
LEFT JOIN spare_part_movement spm ON sp.id = spm.spare_part_id
GROUP BY sp.id, sp.designation, sp.manufacturer
ORDER BY times_used DESC;

-- View current stock levels by plant
SELECT 
    sps.plant_name,
    sp.designation,
    sps.current_stock,
    sps.unit_measure
FROM spare_part_stock sps
JOIN spare_part sp ON sps.spare_part_id = sp.id
WHERE sps.current_stock < 10
ORDER BY sps.plant_name, sps.current_stock; 
