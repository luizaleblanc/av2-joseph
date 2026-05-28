"""Ponto de entrada do backend: cria o app e inicia o servidor Flask."""

from app import create_app

app = create_app()


if __name__ == "__main__":
    app.run(debug=True)

