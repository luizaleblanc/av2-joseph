"""Rotas HTTP de seleções; delega a lógica para selecoes_service."""

from flask import Blueprint, jsonify, request

from app.services.selecoes_service import (
    atualizar_selecao,
    criar_selecao,
    listar_selecoes,
    remover_selecao,
)

selecoes_bp = Blueprint("selecoes", __name__)


@selecoes_bp.route("/listaselecoes", methods=["GET"])
def consultaSelecoes():
    return jsonify(listar_selecoes())


@selecoes_bp.route("/cadastraselecao", methods=["POST"])
def createSelecao():
    return jsonify(criar_selecao(request.get_json()))


@selecoes_bp.route("/atualizaselecao", methods=["PUT"])
def updateSelecao():
    return jsonify(atualizar_selecao(request.get_json()))


@selecoes_bp.route("/removeselecao", methods=["DELETE"])
def deleteSelecao():
    return jsonify(remover_selecao(request.get_json()))

