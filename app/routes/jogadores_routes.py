"""Rotas HTTP de jogadores; delega a lógica para jogadores_service."""

from flask import Blueprint, jsonify, request

from app.services.jogadores_service import (
    atualizar_jogador,
    criar_jogador,
    listar_jogadores,
    remover_jogador,
)

jogadores_bp = Blueprint("jogadores", __name__)


@jogadores_bp.route("/listajogadores", methods=["GET"])
def consultaJogadores():
    return jsonify(listar_jogadores())


@jogadores_bp.route("/cadastrajogador", methods=["POST"])
def createJogador():
    return jsonify(criar_jogador(request.get_json()))


@jogadores_bp.route("/atualizajogador", methods=["PUT"])
def updateJogador():
    return jsonify(atualizar_jogador(request.get_json()))


@jogadores_bp.route("/removejogador", methods=["DELETE"])
def deleteJogador():
    return jsonify(remover_jogador(request.get_json()))

