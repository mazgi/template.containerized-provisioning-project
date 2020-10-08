# template.dockerized-provisioning-project

[![default](https://github.com/mazgi/template.dockerized-provisioning-project/workflows/default/badge.svg)](https://github.com/mazgi/template.dockerized-provisioning-project/actions?query=workflow%3Adefault)

## How to run

You should create a ".env" file as bellows.

```shellsession
cat<<EOE > .env
CLOUDSDK_CORE_PROJECT=YOUR_GCP_PROJECT_ID
CURRENT_ENV_NAME=production
PROJECT_UNIQUE_ID=YOUR_GCP_PROJECT_UNIZUE_ID
EOE
```

If you are using Linux, you should run the command bellows.

```shellsession
echo "UID=$(id -u)\nGID=$(id -g)" >> .env
```

Place the key-file like this.

```shellsession
eval $(op signin my)
source .env
op get document provisioning-owner@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com > config/${CURRENT_ENV_NAME}/credentials/google-cloud-keyfile.json
```

```shellsession
docker-compose up
```
