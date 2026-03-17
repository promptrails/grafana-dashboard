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

# 4. Configure datasource
./setup.sh

# 5. Open
open http://localhost:3333
# Login: admin / admin
```

Dashboards are auto-provisioned in the **PromptRails** folder.

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
3. Set **Name** to `PromptRails`
4. Under **Custom HTTP Headers**, add:
   - Header: `X-API-Key`
   - Value: Your PromptRails API key
5. Under **Security > Allowed Hosts**, add: `api.promptrails.ai`
6. Click **Save & Test**

### 3. Import Dashboards

1. Go to Dashboards > Import
2. Upload JSON files from the `dashboards/` folder:
   - `overview.json` — Main overview dashboard
   - `cost-analysis.json` — Cost breakdown dashboard

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

## License

MIT
