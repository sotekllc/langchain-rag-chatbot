FROM python:3.10-slim

# Install Poetry using official installer
RUN pip install --no-cache-dir poetry==2.1.4

WORKDIR /app

COPY ./src/ /app

COPY ./pyproject.toml poetry.lock /app/
# RUN pip install /code/.
RUN poetry install --no-interaction --no-ansi --no-root

CMD ["sh", "entrypoint.sh"]