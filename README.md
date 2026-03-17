# PromptRails Grafana Dashboard

Pre-built Grafana dashboards for monitoring your PromptRails AI agents, prompts, and costs.

## Dashboards

### Overview
Execution trends, error rates, agent usage, model distribution, and score trends.

### Cost Analysis
Cost breakdown by agent and model, daily cost trends, token usage details.

## Quick Start (Docker)

```bash
# 1. Clone
git clone https://github.com/promptrails/grafana-dashboard
cd grafana-dashboard

# 2. Configure
cp .env.example .env
# Edit .env and set your PROMPTRAILS_API_KEY

# 3. Start
docker-compose up -d

# 4. Open
open http://localhost:3333
# Login: admin / admin
```

Dashboards are auto-provisioned in the **PromptRails** folder. The Docker setup also re-applies the datasource on startup so changes to `PROMPTRAILS_API_KEY` don't get stuck in Grafana's persisted volume.

Use this path if you want the lowest-friction setup. It is the supported reference deployment.

## Manual Import (Existing Grafana)

If you already have a Grafana instance:

### 1. Install Infinity Datasource

```bash
grafana-cli plugins install yesoreyeram-infinity-datasource
```

Or install from Grafana UI: Configuration > Plugins > Search "Infinity"

### 2. Create Datasource

1. Go to Connections > Data Sources > Add data source
2. Search for **Infinity**
3. Create an Infinity datasource with your preferred name
4. Under **Custom HTTP Headers**, add:
   - Header: `X-API-Key`
   - Value: Your PromptRails API key
5. Under **Security > Allowed Hosts**, add: `api.promptrails.ai`
6. Click **Save & Test**

### 3. Import Dashboards

1. Go to Dashboards > Import
2. Upload JSON files from the `exports/` folder:
   - `overview.json` — Main overview dashboard
   - `cost-analysis.json` — Cost breakdown dashboard
3. When Grafana asks for `PromptRails`, select the Infinity datasource you created in the previous step

The `dashboards/` folder is reserved for Docker/provisioning. The `exports/` folder contains import-friendly dashboards that prompt for a datasource during import.

## Repository Layout

- `dashboards/` — Provisioned dashboards used by the Docker setup
- `exports/` — Dashboards to import into an existing Grafana instance
- `provisioning/` — Grafana provisioning files for the Docker setup

## Dashboard Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `days` | `30` | Time range for metrics (7, 14, 30, 60, 90) |

## Panels

### Overview Dashboard
| Panel | Type | Description |
|-------|------|-------------|
| Total Executions | Stat | Total execution count |
| Total Cost | Stat | Cumulative cost in USD |
| Total Tokens | Stat | Total tokens consumed |
| Error Count | Stat | Failed executions (color thresholds) |
| Avg Latency | Stat | Average execution duration |
| Active Agents | Stat | Number of agents |
| Executions Over Time | Bar Chart | Daily execution counts |
| Cost Over Time | Bar Chart | Daily costs |
| Error Rate Over Time | Time Series | Error rate percentage trend |
| Agent Usage | Table | Executions and cost per agent |
| Executions by Agent | Pie Chart | Execution distribution |
| Cost by Agent | Pie Chart | Cost distribution |
| Model Usage | Table | Requests, tokens, cost per model |
| Score Trends | Time Series | Score averages over time |

### Cost Analysis Dashboard
| Panel | Type | Description |
|-------|------|-------------|
| Total Cost | Stat | Overall cost |
| Total Executions | Stat | Overall execution count |
| Total Tokens | Stat | Overall token usage |
| Cost by Agent | Bar Chart | Horizontal bar chart |
| Cost by Model | Bar Chart | Horizontal bar chart |
| Token Usage by Model | Table | Detailed model breakdown |
| Daily Cost Trend | Time Series | Cost bar chart over time |

## API Endpoints Used

- `GET /api/v1/dashboard/metrics?days=N` — Main metrics endpoint
- `GET /api/v1/costs/summary` — Cost summary

## Requirements

- Grafana 10+ (tested with 11.4)
- [Infinity Datasource Plugin](https://grafana.com/grafana/plugins/yesoreyeram-infinity-datasource/)
- PromptRails API key

## Troubleshooting

### `requested URL not allowed`

If Query Inspector also shows a real upstream response like `responseCodeFromServer: 401`, the URL allowlist is probably already correct and the actual problem is authentication.

Check:

1. `Connections > Data Sources > <your Infinity datasource> > Security > Allowed Hosts` contains `api.promptrails.ai`
2. `Connections > Data Sources > <your Infinity datasource> > Custom HTTP Headers` has `X-API-Key`
3. The header value is your current `PROMPTRAILS_API_KEY`

If you imported from `exports/`, also confirm the dashboard was mapped to the correct Infinity datasource during import.

For Docker installs, re-run:

```bash
docker-compose up -d
```

Grafana keeps datasource state in the `grafana-data` volume, so an old API key can survive container restarts unless the datasource is updated again.

## License

MIT
