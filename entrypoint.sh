#!/bin/bash
set -e

# Inicia o Jupyter em segundo plano
jupyter lab --allow-root &

# Inicia o MLflow (opcional)
mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./artifacts --host 0.0.0.0 &

# Mantém o container ativo
tail -f /dev/null