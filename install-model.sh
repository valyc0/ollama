#!/bin/bash

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🤖  Installazione modello LLM via Ollama"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verifica che il container Ollama sia in esecuzione
if ! docker ps --filter "name=ollama" --filter "status=running" | grep -q ollama; then
    echo "❌ Il container Ollama non è in esecuzione."
    echo "   Avvialo prima con: ./start.sh"
    exit 1
fi

# Verifica che Ollama risponda
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "❌ Ollama non risponde su http://localhost:11434"
    exit 1
fi

echo "📋 Modelli già installati:"
docker exec ollama ollama list
echo ""

# ─── Menu selezione modello ───────────────────────────────────────────────────
echo "Scegli il modello da installare:"
echo ""
echo "  1) qwen3-coder       ~ 18 GB  — Qwen3 ottimizzato per coding (Alibaba)"
echo "  2) gemma4:e2b        ~  7 GB  — Gemma 4 efficiente e veloce (Google)"
echo "  3) llama3.2:3b       ~  2 GB  — Llama 3.2 3B multilingua (Meta)"
echo "  4) deepseek-r1:7b    ~  5 GB  — DeepSeek R1 7B con ragionamento avanzato"
echo "  5) phi4-mini         ~  2 GB  — Phi-4 Mini compatto ed efficiente (Microsoft)"
echo ""
read -rp "Inserisci il numero [1-5]: " CHOICE
echo ""

case "$CHOICE" in
    1) MODEL="qwen3-coder" ;;
    2) MODEL="gemma4:e2b" ;;
    3) MODEL="llama3.2:3b" ;;
    4) MODEL="deepseek-r1:7b" ;;
    5) MODEL="phi4-mini" ;;
    *)
        echo "❌ Scelta non valida. Inserisci un numero da 1 a 5."
        exit 1
        ;;
esac

echo "✅ Modello selezionato: $MODEL"
echo ""

# Verifica se il modello esiste già
MODEL_EXISTS=$(docker exec ollama ollama list | grep -c "$MODEL" || true)

if [ "$MODEL_EXISTS" -gt 0 ]; then
    echo "✅ Modello $MODEL già presente"
else
    echo "📥 Download modello $MODEL in corso..."
    echo "   (Questa operazione può richiedere diversi minuti)"
    docker exec ollama ollama pull "$MODEL"

    if [ $? -eq 0 ]; then
        echo "✅ Modello $MODEL scaricato con successo!"
    else
        echo "❌ Errore durante il download del modello $MODEL"
        exit 1
    fi
fi

echo ""
echo "3️⃣  Modelli disponibili:"
docker exec ollama ollama list

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Per testare il modello, esegui:"
echo "   docker exec -it ollama ollama run $MODEL \"Ciao, presentati in una riga\""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
