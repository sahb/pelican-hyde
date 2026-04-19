# Guia de Setup — Blog Pelican com pelican-hyde customizado

Este guia cobre a instalação e configuração completa do blog no Ubuntu 24.04,
incluindo o tema customizado, syntax highlighting, fontes self-hosted,
comentários com Remark42, e deploy.

---

## 1. Instalar dependências do sistema

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv git curl
```


## 2. Criar o projeto Pelican

```bash
# Criar diretório do projeto e virtualenv
mkdir -p ~/meublog && cd ~/meublog
python3 -m venv .venv
source .venv/bin/activate

# Instalar Pelican e Markdown
pip install pelican[markdown] pygments
```


## 3. Inicializar o site (se for a primeira vez)

```bash
pelican-quickstart
```

Responda as perguntas. Os valores mais importantes:

- **Where do you want to create your new web site?** → `.` (diretório atual)
- **URL prefix?** → `https://seublog.com` (ou sua URL)
- **Timezone?** → `Africa/Johannesburg` (ou a do seu servidor)
- **Default language?** → `pt`
- **Do you want to generate a tasks.py/Makefile?** → `Y` (facilita o build)


## 4. Instalar o tema customizado

```bash
# Copiar o tema para uma pasta do projeto
mkdir -p themes
# Extrair o zip do tema nesta pasta:
# (supondo que o zip está em ~/Downloads)
unzip ~/Downloads/pelican-hyde-updated.zip -d themes/
mv themes/pelican-hyde-updated themes/pelican-hyde

# Baixar as fontes self-hosted
cd themes/pelican-hyde
bash download-fonts.sh
cd ~/meublog
```

Verifique que os arquivos woff2 estão em `themes/pelican-hyde/static/fonts/`.


## 5. Configurar o pelicanconf.py

Edite o `pelicanconf.py` na raiz do projeto. Aqui está um exemplo completo
com todas as configurações do tema:

```python
# -*- coding: utf-8 -*-
AUTHOR = 'Seu Nome'
SITENAME = 'Nome do Blog'
SITEURL = ''  # Vazio em dev, definir em publishconf.py
SITESUBTITLE = 'Subtítulo opcional'

PATH = 'content'
TIMEZONE = 'Africa/Johannesburg'
DEFAULT_LANG = 'pt'
DEFAULT_DATE_FORMAT = '%d de %B de %Y'

# Feed (desabilitar em dev)
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Tema
THEME = 'themes/pelican-hyde'

# Sidebar
BIO = 'Uma breve descrição sobre você.'
PROFILE_IMAGE = 'avatar.png'  # Colocar em content/images/
COLOR_THEME = '0d'  # 08=red, 09=orange, 0a=yellow, 0b=green,
                     # 0c=cyan, 0d=blue, 0e=magenta, 0f=brown

# Navegação
DISPLAY_PAGES_ON_MENU = True
MENUITEMS = [
    ('Arquivo', '/archives.html'),
]

# Links sociais (nome = ícone Fork Awesome sem o "fa-")
SOCIAL = [
    ('github', 'https://github.com/seuusuario'),
    ('linkedin', 'https://linkedin.com/in/seuusuario'),
    ('email', 'seuemail@exemplo.com'),
]

FOOTER_TEXT = '© 2026 Seu Nome'

# Markdown — syntax highlighting com números de linha
MARKDOWN = {
    'extension_configs': {
        'markdown.extensions.codehilite': {
            'css_class': 'highlight',
            'linenums': True,
        },
        'markdown.extensions.fenced_code': {},
        'markdown.extensions.extra': {},
    },
    'output_format': 'html5',
}

# Paginação
DEFAULT_PAGINATION = 5

# URLs
ARTICLE_URL = 'posts/{date:%Y}/{date:%m}/{slug}/'
ARTICLE_SAVE_AS = 'posts/{date:%Y}/{date:%m}/{slug}/index.html'

# Arquivos estáticos
STATIC_PATHS = ['images', 'extras']

# Remark42 — comentários self-hosted
REMARK42_URL = 'https://comments.seublog.com'  # URL do seu Remark42
REMARK42_SITE_ID = 'meublog'
REMARK42_LOCALE = 'pt'
REMARK42_THEME = 'light'  # ou 'dark'
```


## 6. Configurar publishconf.py

Este arquivo é usado apenas no build de produção:

```python
# -*- coding: utf-8 -*-
import os
import sys
sys.path.append(os.curdir)
from pelicanconf import *

SITEURL = 'https://seublog.com'
RELATIVE_URLS = False

FEED_ALL_ATOM = 'feeds/all.atom.xml'
DELETE_OUTPUT_DIRECTORY = True
```


## 7. Criar conteúdo

Crie artigos em `content/` como arquivos Markdown:

```bash
mkdir -p content/images
# Colocar seu avatar em content/images/avatar.png
```

Exemplo de post — `content/meu-primeiro-post.md`:

```markdown
Title: Meu primeiro post
Date: 2026-04-18
Tags: pelican, blog
Summary: Um post de teste com syntax highlighting.

Bem-vindo ao meu blog! Aqui está um trecho de código Python:

​```python
def hello(name: str) -> str:
    """Return a greeting message."""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(hello("World"))
​```

E um exemplo em Bash:

​```bash
#!/bin/bash
# List all woff2 font files
find static/fonts -name "*.woff2" -type f | sort
​```
```


## 8. Build local e preview

```bash
cd ~/meublog
source .venv/bin/activate

# Gerar o site
pelican content -s pelicanconf.py

# Servir localmente (http://localhost:8000)
pelican --listen
```

Abra `http://localhost:8000` no navegador para verificar.


## 9. Setup do Remark42 (comentários)

### 9.1. Criar conta no Brevo (SMTP para magic links)

1. Acesse https://www.brevo.com e crie uma conta gratuita.
2. No painel, vá em **Transactional** → **Settings** → **Configuration**.
3. Ative o SMTP transacional.
4. Anote: **SMTP server**, **port**, **login**, **API key** (serve como senha).

O plano gratuito permite 300 emails/dia — mais que suficiente para magic links.


### 9.2. Docker Compose do Remark42

Crie uma pasta para o Remark42 no servidor:

```bash
mkdir -p ~/remark42 && cd ~/remark42
mkdir -p var
```

Crie o `docker-compose.yml`:

```yaml
services:
  remark42:
    image: umputun/remark42:latest
    container_name: remark42
    hostname: remark42
    restart: always
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "5"
    ports:
      - "127.0.0.1:8042:8080"
    environment:
      # --- Core ---
      - REMARK_URL=https://comments.seublog.com
      - SITE=meublog
      - SECRET=GERE_UMA_CHAVE_LONGA_ALEATORIA_AQUI

      # --- Storage ---
      - STORE_BOLT_PATH=/srv/var/db
      - BACKUP_PATH=/srv/var/backup

      # --- Auth: email only (magic link, no OAuth) ---
      - AUTH_EMAIL_ENABLE=true
      - AUTH_EMAIL_FROM=comments@seublog.com
      - AUTH_ANON=false

      # --- SMTP via Brevo ---
      - SMTP_HOST=smtp-relay.brevo.com
      - SMTP_PORT=587
      - SMTP_TLS=true
      - SMTP_USERNAME=seu-login-brevo@email.com
      - SMTP_PASSWORD=sua-api-key-do-brevo

      # --- Notify admin on new comments ---
      - NOTIFY_ADMINS=email
      - NOTIFY_EMAIL_FROM=comments@seublog.com
      - ADMIN_SHARED_EMAIL=seuemail@pessoal.com

    volumes:
      - ./var:/srv/var
```

Substitua:

- `GERE_UMA_CHAVE_LONGA_ALEATORIA_AQUI` — use `openssl rand -base64 32`
- `comments.seublog.com` — o subdomínio apontando para o servidor
- Credenciais SMTP do Brevo

Subir:

```bash
docker compose up -d

# Verificar logs
docker compose logs -f remark42

# Testar: acessar https://comments.seublog.com/web
```


### 9.3. Reverse proxy (Nginx)

Adicione ao Nginx um server block para o subdomínio de comentários:

```nginx
server {
    listen 443 ssl http2;
    server_name comments.seublog.com;

    # SSL — ajustar para seu setup (Let's Encrypt, etc.)
    ssl_certificate     /etc/letsencrypt/live/comments.seublog.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/comments.seublog.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8042;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Se usar Traefik, adicione labels ao container no docker-compose.yml.


### 9.4. Definir admin

Depois do primeiro login por email no Remark42:

1. No log do container, veja o user ID gerado (ex: `email_abc123def456`).
2. Adicione ao docker-compose.yml:
   ```yaml
   - ADMIN_SHARED_ID=email_abc123def456
   ```
3. `docker compose up -d` para reiniciar.


## 10. Build de produção

```bash
cd ~/meublog
source .venv/bin/activate
pelican content -s publishconf.py
```

O site estático fica em `output/`. Copie para o diretório do seu web server:

```bash
rsync -avz --delete output/ /var/www/seublog/
```

Ou, se o servidor for remoto:

```bash
rsync -avz --delete output/ usuario@servidor:/var/www/seublog/
```


## 11. Estrutura final do projeto

```
meublog/
├── content/
│   ├── images/
│   │   └── avatar.png
│   ├── pages/
│   │   └── sobre.md
│   └── meu-primeiro-post.md
├── output/                   ← gerado pelo Pelican (não versionar)
├── themes/
│   └── pelican-hyde/
│       ├── download-fonts.sh
│       ├── static/
│       │   ├── css/
│       │   │   ├── fonts.css
│       │   │   ├── poole.css
│       │   │   ├── hyde.css
│       │   │   ├── syntax.css
│       │   │   └── style.css
│       │   └── fonts/
│       │       ├── literata-v400-latin.woff2
│       │       ├── inter-v400-latin.woff2
│       │       ├── abril-fatface-v400-latin.woff2
│       │       ├── jetbrains-mono-v400-latin.woff2
│       │       └── ... (12 arquivos woff2)
│       └── templates/
│           ├── base.html
│           ├── sidebar.html
│           ├── index.html
│           ├── article.html
│           └── fragments/
│               ├── remark42.html
│               ├── disqus.html
│               ├── feeds.html
│               └── google_analytics.html
├── pelicanconf.py
├── publishconf.py
└── .venv/
```


## 12. Checklist rápido

- [ ] Python 3 + venv instalados
- [ ] `pip install pelican[markdown] pygments`
- [ ] Tema extraído em `themes/pelican-hyde/`
- [ ] `bash download-fonts.sh` executado (12 arquivos woff2)
- [ ] `pelicanconf.py` configurado (THEME, MARKDOWN, REMARK42_URL)
- [ ] Avatar em `content/images/avatar.png`
- [ ] Pelo menos um post em `content/`
- [ ] `pelican content && pelican --listen` funciona local
- [ ] Remark42 rodando via Docker
- [ ] Brevo SMTP configurado e testado
- [ ] DNS do subdomínio de comentários apontando pro servidor
- [ ] Nginx/Traefik com reverse proxy para o Remark42
- [ ] Build de produção com `publishconf.py` e deploy via rsync
