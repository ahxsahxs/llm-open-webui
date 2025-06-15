# AI Chatbot Platform with Open WebUI

A complete, self-contained AI chatbot platform combining Open WebUI, Ollama, Docling document processing, and Qdrant vector database for advanced RAG (Retrieval-Augmented Generation) capabilities.

## 🚀 Features

- **Open WebUI**: Modern web interface for AI interactions with GPU acceleration
- **Ollama**: Local LLM serving with automatic Gemma3 model download
- **Docling**: Advanced document processing with OCR support for multiple languages
- **Qdrant**: High-performance vector database optimized for similarity search
- **PostgreSQL**: Primary database for application data
- **Advanced RAG**: Optimized document retrieval with reranking and chunking
- **MCP Tools Support**: Compatible with Haystack Hayhooks for easy tool integration
- **Multi-language OCR**: Support for English, French, German, and Spanish
- **GPU Acceleration**: CUDA support across all compatible services

## 📋 Prerequisites

- Docker and Docker Compose
- NVIDIA GPU with CUDA support
- NVIDIA Container Toolkit installed
- At least 8GB GPU memory recommended
- 16GB+ system RAM recommended

### Installing NVIDIA Container Toolkit

```bash
# Ubuntu/Debian
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

## 🔧 Configuration Setup

Before starting the platform, you need to configure the following environment variables in the `docker-compose.yml`:

### Required Configuration

Replace the following placeholders with your actual values:

```yaml
# PostgreSQL credentials
POSTGRES_USER: __PG_USER__        # Replace with your PostgreSQL username
POSTGRES_PASSWORD: __PG_PASS__    # Replace with your PostgreSQL password

# Qdrant API key
QDRANT_API_KEY: __QDRANT_KEY__    # Replace with your Qdrant API key
```

### Example Configuration

```yaml
environment:
  POSTGRES_USER: myuser
  POSTGRES_PASSWORD: mypassword123
  QDRANT_API_KEY: my-secure-qdrant-key-2024
```

## 🛠️ Quick Start

1. **Configure environment variables** as described above

2. **Start the platform**:
   ```bash
   docker-compose up -d
   ```

3. **Wait for initialization** (first run may take several minutes):
   - Gemma3 model will be automatically downloaded
   - Docling models will be initialized
   - Databases will be set up

4. **Access the services**:
   - **Open WebUI**: http://localhost:3000
   - **Docling UI**: http://localhost:5001
   - **Qdrant Dashboard**: http://localhost:6333/dashboard
   - **PostgreSQL**: localhost:5432

## 🔧 Service Details

### Open WebUI (Port 3000)
- **Image**: `ghcr.io/open-webui/open-webui:cuda`
- **Purpose**: Main chat interface with GPU acceleration
- **Default Model**: Gemma3 (automatically configured)
- **Features**: Advanced RAG, document processing, vector search
- **Permissions**: Streamlined for focused chatbot usage

### Ollama (Port 7869)
- **Image**: `ollama/ollama:latest`
- **Purpose**: Local LLM serving
- **Auto-download**: Gemma3 model on first startup
- **Features**: Model persistence, 24-hour keep-alive
- **Storage**: Persistent model cache

### Docling (Port 5001)
- **Image**: `quay.io/docling-project/docling-serve-cu124`
- **Purpose**: Document processing and OCR
- **Features**: Multi-language OCR, PDF image extraction, GPU acceleration
- **Cache**: Persistent model cache for faster processing

### Qdrant (Ports 6333, 6334)
- **Image**: `qdrant/qdrant:latest`
- **Purpose**: High-performance vector database
- **Features**: Optimized similarity search, REST API, web dashboard
- **Storage**: Persistent vector data

### PostgreSQL (Port 5432)
- **Image**: `postgres:latest`
- **Purpose**: Primary application database
- **Features**: User data, chat history, configurations
- **Health checks**: Automatic readiness monitoring

## 📁 Data Persistence

All data is stored in named Docker volumes:
- `open-webui`: Open WebUI data and configurations
- `ollama`: Downloaded LLM models (includes Gemma3)
- `docling_cache`: Docling model cache for faster processing
- `qdrant_data`: Vector embeddings and search indices
- `pgdata`: PostgreSQL database

## ⚙️ Advanced RAG Configuration

The platform includes optimized RAG settings:

```yaml
# Retrieval Settings
RAG_TOP_K: 50                           # Top documents retrieved
RAG_TOP_K_RERANKER: 10                  # Documents after reranking
RAG_TEXT_SPLITTER: token                # Token-based text splitting

# Chunking Configuration  
CHUNK_SIZE: 1024                        # Size of text chunks
CHUNK_OVERLAP: 100                      # Overlap between chunks

# File Processing
PDF_EXTRACT_IMAGES: true                # Extract images from PDFs
RAG_FILE_MAX_SIZE: 5120                 # Max file size (KB)
RAG_FILE_MAX_COUNT: 20                  # Max files per collection
RAG_ALLOWED_FILE_EXTENSIONS: pdf,docx,txt
```

### Customizing RAG Settings

To optimize for your use case, modify these environment variables:

```yaml
# For longer documents
- CHUNK_SIZE=2048
- CHUNK_OVERLAP=200

# For more precise retrieval
- RAG_TOP_K=100
- RAG_TOP_K_RERANKER=20

# For additional file types
- RAG_ALLOWED_FILE_EXTENSIONS=pdf,docx,txt,md,html
```

## 🤖 Using the Platform

### First Time Setup

1. **Access Open WebUI** at http://localhost:3000
2. **Create an admin account** on first visit
3. **Gemma3 model** will be ready automatically
4. **Optional**: Download additional models:
   ```bash
   docker exec -it ollama ollama pull llama3.1:8b
   docker exec -it ollama ollama pull mistral:7b
   ```

### Document Processing & RAG

1. **Upload documents** (PDF, DOCX, TXT) through the Open WebUI interface
2. **Automatic processing**:
   - Documents processed by Docling with OCR
   - Text chunked with overlap for better context
   - Images extracted from PDFs
   - Vector embeddings stored in Qdrant
3. **Intelligent retrieval**:
   - Top 50 relevant chunks retrieved
   - Reranked to top 10 most relevant
   - Context provided to the LLM

### Qdrant Vector Database

Access the Qdrant dashboard at http://localhost:6333/dashboard to:
- Monitor vector collections
- View search statistics
- Manage vector data
- Test similarity searches

## 🔌 MCP Tools Integration

This platform supports MCP (Model Context Protocol) tools through Haystack Hayhooks:

```python
# Example tool configuration
from haystack import Pipeline
from qdrant_haystack import QdrantDocumentStore

# Connect to Qdrant for custom tools
document_store = QdrantDocumentStore(
    host="localhost",
    port=6333,
    api_key="your-qdrant-key",
    index="your_collection"
)
```

## 📊 Monitoring and Logs

### View Service Logs
```bash
# All services
docker-compose logs -f

# Specific services
docker-compose logs -f openwebui
docker-compose logs -f ollama
docker-compose logs -f qdrant
```

### Health Checks
```bash
# PostgreSQL health
docker exec postgres pg_isready

# Qdrant status
curl http://localhost:6333/health

# Ollama models
docker exec ollama ollama list
```

## 🛠️ Maintenance

### Updating Services
```bash
docker-compose pull
docker-compose up -d
```

### Backing Up Data
```bash
# Backup Open WebUI data
docker run --rm -v open-webui:/data -v $(pwd):/backup alpine tar czf /backup/open-webui-backup.tar.gz -C /data .

# Backup Ollama models
docker run --rm -v ollama:/data -v $(pwd):/backup alpine tar czf /backup/ollama-backup.tar.gz -C /data .

# Backup Qdrant vectors
docker run --rm -v qdrant_data:/data -v $(pwd):/backup alpine tar czf /backup/qdrant-backup.tar.gz -C /data .

# Backup PostgreSQL
docker exec postgres pg_dump -U __PG_USER__ main_db > backup.sql
```

### Managing Models
```bash
# List available models
docker exec ollama ollama list

# Remove unused models
docker exec ollama ollama rm model_name

# Pull specific model versions
docker exec ollama ollama pull gemma3:2b
```

## 🚨 Troubleshooting

### Configuration Issues
```bash
# Check if placeholders are replaced
grep -n "__.*__" docker-compose.yml

# Should return no results if properly configured
```

### GPU Not Detected
```bash
# Test NVIDIA runtime
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

### Database Connection Issues
```bash
# PostgreSQL connection
docker exec postgres pg_isready -U __PG_USER__

# Qdrant status
curl -X GET "http://localhost:6333/health"
```

### Qdrant Collection Issues
```bash
# List collections
curl -X GET "http://localhost:6333/collections"

# Collection info
curl -X GET "http://localhost:6333/collections/{collection_name}"
```

### Model Download Problems
```bash
# Check Ollama logs
docker logs ollama

# Manually pull Gemma3
docker exec ollama ollama pull gemma3:latest
```

## 📈 Performance Optimization

### GPU Memory Management
- Monitor usage: `nvidia-smi`
- Adjust model selection based on VRAM
- Use quantized models for better performance


### RAG Performance Tuning
- Increase `RAG_TOP_K` for broader context
- Decrease `CHUNK_SIZE` for more precise matching
- Adjust `CHUNK_OVERLAP` for better context continuity

## 🔒 Security Considerations

- **Change default credentials** before production use
- **Use strong API keys** for Qdrant
- **Limit file upload sizes** with `RAG_FILE_MAX_SIZE`
- **Restrict file types** with `RAG_ALLOWED_FILE_EXTENSIONS`
- **Monitor resource usage** to prevent abuse

## 🆘 Support

For configuration-specific issues:
1. **Check logs**: `docker-compose logs [service]`
2. **Verify configuration**: Ensure no `__PLACEHOLDER__` values remain
3. **Test connections**: Use provided health check commands
4. **GPU availability**: Run `nvidia-smi`

For component-specific issues, refer to:
- [Open WebUI Documentation](https://docs.openwebui.com/)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Qdrant Documentation](https://qdrant.tech/documentation/)
- [Docling Documentation](https://github.com/DS4SD/docling)

## 📄 License

This configuration uses open-source components. Please check individual component licenses for compliance requirements.