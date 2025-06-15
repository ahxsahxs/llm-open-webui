import os
import psycopg
from psycopg.rows import dict_row
from psycopg import OperationalError

def get_postgres_connection():
    """
    Create and return a PostgreSQL connection using environment variables.
    
    Expected environment variables:
    - DB_HOST: Database host (default: localhost)
    - DB_PORT: Database port (default: 5432)
    - DB_NAME: Database name (required)
    - DB_USER: Database username (required)
    - DB_PASSWORD: Database password (required)
    - DB_SSLMODE: SSL mode (optional, default: prefer)
    
    Returns:
        psycopg.Connection: PostgreSQL connection object
        
    Raises:
        ValueError: If required environment variables are missing
        OperationalError: If connection to database fails
    """
    # Get environment variables
    host = os.getenv('DB_HOST', 'localhost')
    port = os.getenv('DB_PORT', '5432')
    database = os.getenv('DB_NAME')
    user = os.getenv('DB_USER')
    password = os.getenv('DB_PASSWORD')
    sslmode = os.getenv('DB_SSLMODE', 'prefer')
    
    # Check for required variables
    if not database:
        raise ValueError("DB_NAME environment variable is required")
    if not user:
        raise ValueError("DB_USER environment variable is required")
    if not password:
        raise ValueError("DB_PASSWORD environment variable is required")
    
    try:
        # Create connection string
        conninfo = f"host={host} port={port} dbname={database} user={user} password={password} sslmode={sslmode}"
        
        # Create connection
        connection = psycopg.connect(conninfo, row_factory=dict_row)
        return connection
        
    except OperationalError as e:
        raise OperationalError(f"Failed to connect to PostgreSQL database: {e}")

def get_postgres_connection_async():
    """
    Create and return an async PostgreSQL connection using environment variables.
    
    Returns:
        psycopg.AsyncConnection: Async PostgreSQL connection object
    """
    # Get environment variables (same as sync version)
    host = os.getenv('DB_HOST', 'localhost')
    port = os.getenv('DB_PORT', '5432')
    database = os.getenv('DB_NAME')
    user = os.getenv('DB_USER')
    password = os.getenv('DB_PASSWORD')
    sslmode = os.getenv('DB_SSLMODE', 'prefer')
    
    # Check for required variables
    if not database:
        raise ValueError("DB_NAME environment variable is required")
    if not user:
        raise ValueError("DB_USER environment variable is required")
    if not password:
        raise ValueError("DB_PASSWORD environment variable is required")
    
    try:
        # Create connection string
        conninfo = f"host={host} port={port} dbname={database} user={user} password={password} sslmode={sslmode}"
        
        # Create async connection
        connection = psycopg.AsyncConnection.connect(conninfo)
        return connection
        
    except OperationalError as e:
        raise OperationalError(f"Failed to connect to PostgreSQL database: {e}")

# Example usage:
if __name__ == "__main__":
    # Synchronous example
    try:
        os.environ['DB_NAME'] = 'postgres'
        os.environ['DB_USER'] = '__PG_USER__'
        os.environ['DB_PASSWORD'] = '__PG_PASS__'
        conn = get_postgres_connection()
        print("Successfully connected to PostgreSQL!")
        
        # Test the connection
        with conn.cursor() as cursor:
            cursor.execute("SELECT version();")
            version = cursor.fetchone()
            print(f"PostgreSQL version: {version}")
            
        conn.close()
        
    except (ValueError, OperationalError) as e:
        print(f"Error: {e}")
    
    # Async example (uncomment to use)
    """
    import asyncio
    
    async def test_async_connection():
        try:
            conn = await get_postgres_connection_async()
            print("Successfully connected to PostgreSQL (async)!")
            
            async with conn.cursor() as cursor:
                await cursor.execute("SELECT version();")
                version = await cursor.fetchone()
                print(f"PostgreSQL version: {version[0]}")
                
            await conn.close()
            
        except (ValueError, OperationalError) as e:
            print(f"Async Error: {e}")
    
    # Run async example
    asyncio.run(test_async_connection())
    """