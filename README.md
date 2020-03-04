# Ambientes MySQL
Arquivos de configuração de ambientes utilizados para benchmarks de estratégias de escalabilidade. Entre as estratégias configuradas estão:
- Replicação
- Particionamento funcional
- Data sharding
- Clustering (MySQL NDB Cluster)


Os ambientes foram configurados utilizando a ferramenta de orquestração de containers Kubernetes. Os diretórios do projeto estão divididos da seguinte forma:

- `/benchs`: Possui os scripts utilizados para a execução dos benchmarks nos ambientes.
- `/confs`: Arquivos de configurações do MySQL, utilizado para configuração de cada ambiente.
- `/data`: Diretório de dados destino para a execução dos ambientes via `docker-compose`.
- `/images`: Dockerfiles das imagens.
- `/kube`: Arquivos do Kubernetes utilizados para delpoy dos ambientes.
- `/scripts`: Scripts de inicialização dos ambientes.

As análises e resultados estão disponíveis na monografia [Proposta de Estratégia para Análise de Escalabilidade do SGBD MYSQL](https://pt.slideshare.net/casscarraro/proposta-de-estratgia-para-anlise-de-escalabilidade-do-sgbd-mysql).
