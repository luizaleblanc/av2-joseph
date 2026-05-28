"""Rotas HTTP de partidas; delega a lógica para partidas_service."""

from flask import Blueprint, jsonify, request

from app.services.partidas_service import (
    atualizar_partida,
    criar_partida,
    listar_partidas_detalhada,
    remover_partida,
)

partidas_bp = Blueprint("partidas", __name__)


@partidas_bp.route("/listapartidasdetalhada", methods=["GET"])
def consultaPartidasDetalhada():
    return jsonify(listar_partidas_detalhada())


@partidas_bp.route("/cadastrapartida", methods=["POST"])
def createPartida():
    return jsonify(criar_partida(request.get_json()))


@partidas_bp.route("/atualizapartida", methods=["PUT"])
def updatePartida():
    return jsonify(atualizar_partida(request.get_json()))


@partidas_bp.route("/removepartida", methods=["DELETE"])
def deletePartida():
    return jsonify(remover_partida(request.get_json()))

