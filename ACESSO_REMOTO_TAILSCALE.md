# Acesso Remoto ao Home Assistant via Tailscale Funnel

## Seu Setup

- **HA Server**: GMKtec G9 em `192.168.0.84:8123`
- **HA OS**: Home Assistant OS 13.2 (generic-x86-64)
- **Objetivo**: Acessar o HA de qualquer lugar (incluindo Claude Code web) sem abrir portas

## 3 Passos

### Passo 1: Configurar o Tailscale Admin Console

1. Crie uma conta em https://login.tailscale.com (gratis ate 100 devices)
2. Va em **DNS** → escolha um dominio (ex: `tailnet-xxxx.ts.net`) → ative **Enable HTTPS**
3. Va em **Access Controls** → adicione o bloco abaixo no ACL (antes do ultimo `}`):

```json
"nodeAttrs": [
  {
    "target": ["autogroup:member"],
    "attr":   ["funnel"]
  }
]
```

### Passo 2: Instalar e Configurar o Add-on no Home Assistant

1. No HA, va em **Settings → Add-ons → ADD-ON STORE**
2. Pesquise **Tailscale** e instale o add-on da comunidade
3. Na aba **Configuration** do add-on, configure:

```yaml
share_homeassistant: funnel
share_on_port: 443
advertise_exit_node: false
advertise_routes:
  - local_subnets
accept_dns: true
accept_routes: true
userspace_networking: true
taildrop: true
log_level: info
```

4. **Nao inicie o add-on ainda** → va ao Passo 3 primeiro

### Passo 3: Configurar o HTTP do Home Assistant

1. No HA, va em **Settings → Add-ons → File Editor** (instale se nao tiver)
2. Abra o arquivo `/config/configuration.yaml`
3. Adicione ou edite a secao `http:`:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
```

4. **Reinicie o Home Assistant** (Settings → System → Restart)
5. Agora **inicie o add-on Tailscale**
6. Veja os **logs do add-on** → tera um link para autenticar no Tailscale
7. Siga o link e autorize o dispositivo

### Pos-Configuracao

1. No Tailscale Admin Console, encontre o device `homeassistant`
2. Clique nos `...` → **Disable key expiry** (para nao expirar)
3. O Funnel leva alguns minutos para ativar
4. Seu HA estara acessivel em: `https://homeassistant.<seu-tailnet>.ts.net`

## Resultado

```
Qualquer lugar (Claude Code, celular, trabalho)
        ↓ HTTPS
https://homeassistant.tailnet-xxxx.ts.net
        ↓ Tailscale Funnel (WireGuard)
GMKtec G9 (192.168.0.84:8123)
        ↓
Home Assistant
```

- Zero portas abertas no router
- HTTPS automatico (certificado Tailscale/Let's Encrypt)
- Sem VPS, sem custo, sem manutencao

## Seguranca

- Use senhas fortes e unicas para todas as contas HA
- Ative autenticacao de 2 fatores (MFA) no Tailscale
- O Funnel expoe a tela de login do HA na internet → senhas fracas = risco
- Considere ativar `ip_ban_enabled: true` no HA para bloquear brute force:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1
  ip_ban_enabled: true
  login_attempts_threshold: 5
```

## Referencia

- [Tailscale + Home Assistant (oficial)](https://tailscale.com/blog/remotely-access-home-assistant)
- [Add-on Tailscale (GitHub)](https://github.com/hassio-addons/addon-tailscale)
- [HA Remote Access (docs oficiais)](https://www.home-assistant.io/docs/configuration/remote/)
- [Tailscale Funnel setup (community)](https://community.home-assistant.io/t/how-to-set-up-tailscale-funnel-to-securely-access-home-assistant-from-anywhere-for-free/950072)
