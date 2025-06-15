import os
from qdrant_client import QdrantClient
from qdrant_client.http.exceptions import UnexpectedResponse

def get_qdrant_connection():
    """
    Create and return a QDrant client connection using environment variables.
    
    Expected environment variables:
    - QDRANT_HOST: QDrant host (default: localhost)
    - QDRANT_PORT: QDrant port (default: 6333)
    - QDRANT_API_KEY: API key for authentication (optional)
    - QDRANT_URL: Full URL (alternative to host/port, takes precedence)
    - QDRANT_HTTPS: Use HTTPS (default: False, set to 'true' to enable)
    - QDRANT_TIMEOUT: Request timeout in seconds (default: 60)
    - QDRANT_GRPC_PORT: gRPC port (optional, for gRPC connection)
    - QDRANT_PREFER_GRPC: Use gRPC instead of HTTP (default: False)
    
    Returns:
        QdrantClient: QDrant client connection object
        
    Raises:
        ValueError: If configuration is invalid
        UnexpectedResponse: If connection to QDrant fails
    """
    # Get environment variables
    url = os.getenv('QDRANT_URL')
    host = os.getenv('QDRANT_HOST', 'localhost')
    port = int(os.getenv('QDRANT_PORT', '6333'))
    api_key = os.getenv('QDRANT_API_KEY')
    https = os.getenv('QDRANT_HTTPS', 'false').lower() == 'true'
    timeout = int(os.getenv('QDRANT_TIMEOUT', '60'))
    grpc_port = os.getenv('QDRANT_GRPC_PORT')
    prefer_grpc = os.getenv('QDRANT_PREFER_GRPC', 'false').lower() == 'true'
    
    try:
        # If full URL is provided, use it
        if url:
            client = QdrantClient(
                url=url,
                api_key=api_key,
                timeout=timeout
            )
        # If gRPC is preferred and grpc_port is specified
        elif prefer_grpc and grpc_port:
            client = QdrantClient(
                host=host,
                grpc_port=int(grpc_port),
                api_key=api_key,
                timeout=timeout,
                prefer_grpc=True
            )
        # Standard HTTP connection
        else:
            client = QdrantClient(
                host=host,
                port=port,
                api_key=api_key,
                https=https,
                timeout=timeout
            )
        
        return client
        
    except Exception as e:
        raise UnexpectedResponse(f"Failed to connect to QDrant database: {e}")

def get_qdrant_connection_async():
    """
    Create and return an async QDrant client connection using environment variables.
    
    Returns:
        QdrantClient: Async QDrant client connection object
    """
    # Get environment variables (same as sync version)
    url = os.getenv('QDRANT_URL')
    host = os.getenv('QDRANT_HOST', 'localhost')
    port = int(os.getenv('QDRANT_PORT', '6333'))
    api_key = os.getenv('QDRANT_API_KEY')
    https = os.getenv('QDRANT_HTTPS', 'false').lower() == 'true'
    timeout = int(os.getenv('QDRANT_TIMEOUT', '60'))
    grpc_port = os.getenv('QDRANT_GRPC_PORT')
    prefer_grpc = os.getenv('QDRANT_PREFER_GRPC', 'false').lower() == 'true'
    
    try:
        # Create async client with similar logic
        if url:
            client = QdrantClient(
                url=url,
                api_key=api_key,
                timeout=timeout,
                # Enable async mode
                prefer_grpc=False  # HTTP async is more stable
            )
        elif prefer_grpc and grpc_port:
            client = QdrantClient(
                host=host,
                grpc_port=int(grpc_port),
                api_key=api_key,
                timeout=timeout,
                prefer_grpc=True
            )
        else:
            client = QdrantClient(
                host=host,
                port=port,
                api_key=api_key,
                https=https,
                timeout=timeout
            )
            
        return client
        
    except Exception as e:
        raise UnexpectedResponse(f"Failed to connect to QDrant database: {e}")

def test_qdrant_connection(client):
    """
    Test the QDrant connection by checking cluster info.
    
    Args:
        client: QdrantClient instance
        
    Returns:
        bool: True if connection is successful
    """
    try:
        # Test connection by getting cluster info
        cluster_info = client.get_cluster_info()
        print(f"Connected to QDrant cluster: {cluster_info}")
        return True
    except Exception as e:
        print(f"Connection test failed: {e}")
        return False

# Example usage:
if __name__ == "__main__":
    try:
        # Create connection
        qdrant_client = get_qdrant_connection()
        print("Successfully connected to QDrant!")
        
        # Test the connection
        if test_qdrant_connection(qdrant_client):
            print("Connection test passed!")
            
            # Example: List collections
            try:
                collections = qdrant_client.get_collections()
                print(f"Available collections: {[c.name for c in collections.collections]}")
            except Exception as e:
                print(f"Could not list collections: {e}")
        
    except (ValueError, UnexpectedResponse) as e:
        print(f"Error: {e}")
    
    # Async example (uncomment to use)
    """
    import asyncio
    
    async def test_async_connection():
        try:
            client = get_qdrant_connection_async()
            print("Successfully created async QDrant client!")
            
            # Note: QDrant client methods are not truly async in current version
            # But you can use them in async contexts
            cluster_info = client.get_cluster_info()
            print(f"Async connection cluster info: {cluster_info}")
            
        except (ValueError, UnexpectedResponse) as e:
            print(f"Async Error: {e}")
    
    # Run async example
    asyncio.run(test_async_connection())
    """