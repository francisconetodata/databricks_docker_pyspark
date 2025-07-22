# Use a imagem oficial do Spark com Python
FROM apache/spark-py:3.5.0

# Mantenedor
LABEL maintainer="Seu Nome <seu.email@exemplo.com>"

# Configurações de ambiente
ENV SPARK_HOME=/opt/spark \
    PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.7-src.zip \
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 \
    MLFLOW_TRACKING_URI=http://localhost:5000

# Instala dependências do sistema
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    openjdk-11-jdk-headless \
    python3-pip \
    python3-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Instala pacotes Python essenciais
RUN pip install --upgrade pip && \
    pip install \
    jupyterlab \
    pandas \
    numpy \
    scikit-learn \
    matplotlib \
    seaborn \
    mlflow \
    pyspark==3.5.0 \
    databricks-connect==14.1.0 \
    delta-spark==3.0.0 \
    ipywidgets

# Configura o Jupyter
RUN jupyter notebook --generate-config && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.port = 8888" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

# Diretório de trabalho
WORKDIR /workspace
VOLUME /workspace

# Expõe portas importantes
EXPOSE 4040 5000 8888 8080

# Script de inicialização
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
