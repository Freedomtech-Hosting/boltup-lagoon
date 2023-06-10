FROM apotdevin/thunderhub:v0.13.19

COPY thunderhub/thubConfig.yaml /thubConfig.yaml
ENV ACCOUNT_CONFIG_PATH=/thubConfig.yaml

CMD [ "node", "dist/main" ]