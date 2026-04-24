# Ollama Docker Setup

Setup Docker per eseguire [Ollama](https://ollama.com/) in locale, con download automatico del modello `llama3.2:1b` al primo avvio e uno script interattivo per installare modelli aggiuntivi.

## Cosa fa questo progetto

- Avvia un container Docker con **Ollama**, il runtime locale per LLM (Large Language Models)
- Espone l'API REST di Ollama su `http://localhost:11434`
- Scarica automaticamente il modello `llama3.2:1b` se non è già presente
- Persiste i modelli scaricati in un volume Docker (`ollama_data`), evitando re-download ad ogni riavvio
- Fornisce uno script interattivo per installare modelli aggiuntivi a scelta

## Prerequisiti

- [Docker](https://docs.docker.com/get-docker/) con il plugin Compose (`docker compose`)
- Connessione Internet per il download dei modelli

## Quick Start

```bash
# Rendi eseguibili gli script
chmod +x start.sh install-model.sh

# Avvia Ollama e scarica llama3.2:1b
./start.sh
```

Al termine, Ollama è disponibile su `http://localhost:11434`.

## Installare un modello aggiuntivo

```bash
./install-model.sh
```

Lo script presenta un menu interattivo con i seguenti modelli disponibili:

| # | Modello | Dimensione | Note |
|---|---------|-----------|------|
| 1 | `qwen3-coder` | ~18 GB | Ottimizzato per coding (Alibaba) |
| 2 | `gemma4:e2b` | ~7 GB | Efficiente e veloce (Google) |
| 3 | `llama3.2:3b` | ~2 GB | Multilingua (Meta) |
| 4 | `deepseek-r1:7b` | ~5 GB | Ragionamento avanzato (DeepSeek) |
| 5 | `phi4-mini` | ~2 GB | Compatto ed efficiente (Microsoft) |

## Struttura del progetto

```
ollama/
├── docker-compose.yml   # Definisce il servizio Ollama e il volume dati
├── start.sh             # Avvia il container e scarica llama3.2:1b
├── install-model.sh     # Script interattivo per installare modelli aggiuntivi
└── README.md
```

## Comandi utili

```bash
# Avvia il container in background
docker compose up -d

# Verifica stato del container
docker compose ps

# Segui i log in tempo reale
docker compose logs -f ollama

# Elenca i modelli installati
docker exec ollama ollama list

# Testa un modello in modalità interattiva
docker exec -it ollama ollama run llama3.2:1b

# Scarica manualmente un modello
docker exec ollama ollama pull mistral

# Ferma il container
docker compose down

# Ferma il container e cancella i modelli scaricati
docker compose down -v
```

## API REST

Ollama espone un'API HTTP compatibile con OpenAI. Esempio di utilizzo:

```bash
curl http://localhost:11434/api/generate \
  -d '{"model": "llama3.2:1b", "prompt": "Ciao! Presentati in una riga.", "stream": false}'
```

La stessa API può essere usata come backend per sistemi RAG, chatbot e qualsiasi applicazione che richieda un LLM locale.

1. Avvia Ollama:
```bash
cd ollama
./start.sh
```

2. Configura il RAG system per usare Ollama:
```bash
cd ..
export LLM_PROVIDER=ollama
export OLLAMA_MODEL=llama3.2:1b
./start.sh
```

## Modelli Disponibili

- `llama3.2:1b` - Velocissimo, 1B parametri (~1GB)
- `llama3.2` - Default 3B parametri (~2GB)
- `llama3.1` - Più potente, 8B parametri (~4.7GB)
- `mistral` - Ottimo rapporto qualità/velocità, 7B (~4GB)
- `phi3` - Compatto, 3.8B parametri (~2.3GB)

Scarica altri modelli:
```bash
docker exec ollama ollama pull <model-name>
```

## Note

- I modelli vengono salvati nel volume Docker `ollama_data`
- Alla prima esecuzione il download del modello può richiedere qualche minuto
- Porta: `11434` (default Ollama)
