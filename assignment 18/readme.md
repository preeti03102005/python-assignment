## Build Docker Image

```bash
docker build -t pyspark-dataframe .
```

## Run Docker Container


```powershell
docker run -it --rm -p 8080:8080 -v "${PWD}:/workspace" pyspark-dataframe
```

## Access JupyterLab

Open the URL displayed in the terminal, for example:

```text
http://localhost:8080/lab?token=<generated-token>
```