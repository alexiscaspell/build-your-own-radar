FROM node:10.15.3 as source
WORKDIR /src/build-your-own-radar
COPY package.json ./

RUN npm install

COPY . ./

RUN npm run build

# FROM nginx:1.15.9
FROM tiangolo/uwsgi-nginx:python3.8
WORKDIR /opt/build-your-own-radar
COPY --from=source /src/build-your-own-radar/dist .

COPY src/sheets/ sheets/
# COPY default.template /app/nginx.conf
COPY default.template /app/nginx-server.conf
# CMD ["nginx", "-g", "daemon off;"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /app

# Copy start.sh script that will check for a /app/prestart.sh script and run it before starting the app
COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY token.json /app/token.json

COPY main.py /app/main.py

# Run the start script, it will check for an /app/prestart.sh script (e.g. for migrations)
# And then will start Supervisor, which in turn will start Nginx and uWSGI
CMD ["/start.sh"]
