"""Rotas HTTP de autenticação e perfil; delega a lógica para auth_service."""

from flask import Blueprint, jsonify, request

from app.services.auth_service import (
    alterar_senha_por_recuperacao,
    atualizar_perfil_usuario,
    buscar_pergunta_seguranca,
    cadastro_usuario,
    login_usuario,
)

auth_bp = Blueprint("auth", __name__)


@auth_bp.route("/cadastro", methods=["POST"])
def cadastro():
    return jsonify(cadastro_usuario(request.get_json()))


@auth_bp.route("/login", methods=["POST"])
def login():
    return jsonify(login_usuario(request.get_json()))


@auth_bp.route("/recuperar/pergunta", methods=["POST"])
def buscar_pergunta():
    return jsonify(buscar_pergunta_seguranca(request.get_json()))


@auth_bp.route("/recuperar/senha", methods=["POST"])
def alterar_senha_recuperacao():
    return jsonify(alterar_senha_por_recuperacao(request.get_json()))


@auth_bp.route("/perfil/atualizar", methods=["PUT"])
def atualizar_perfil():
    return jsonify(atualizar_perfil_usuario(request.get_json()))

