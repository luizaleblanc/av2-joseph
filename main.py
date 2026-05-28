import os
from flask import Flask, jsonify, request
from flask_cors import CORS 
import pymysql

app = Flask(__name__)
CORS(app) 

def conectaBanco():
    return pymysql.connect(
        database='copado_mundo',
        host='localhost',
        user='root',
        passwd=os.getenv('MYSQL_PASSWORD', 'annyacernitrov15'),
        charset='utf8mb4'
    )

##################### AUTENTICAÇÃO & PERFIL #############################

# REGISTRO DE USUÁRIO
@app.route('/cadastro', methods=['POST'])
def cadastro():
    dados = request.get_json()
    nome = dados['nome']
    email = dados['email']
    senha = dados['senha']
    tipo = dados.get('tipo_usuario') 
    pergunta = dados['pergunta_seguranca']
    resposta = dados['resposta_seguranca']

    bd = conectaBanco()
    cursor = bd.cursor()
    try:
        sql = "INSERT INTO usuario (nome, email, senha, tipo_usuario, pergunta_seguranca, resposta_seguranca) VALUES (%s, %s, %s, %s, %s, %s);"
        cursor.execute(sql, (nome, email, senha, tipo, pergunta, resposta))
        bd.commit()
        mensagem = {"mensagem": "Usuário cadastrado com sucesso!", "code": 201}
    except pymysql.MySQLError:
        mensagem = {"mensagem": "Erro ao cadastrar. Email já cadastrado no sistema.", "code": 400}
    finally:
        bd.close()
    return jsonify(mensagem)

# LOGIN DE USUÁRIO
@app.route('/login', methods=['POST'])
def login():
    dados = request.get_json()
    email = dados['email']
    senha = dados['senha']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "SELECT id_usuario, nome, email, tipo_usuario FROM usuario WHERE email = %s AND senha = %s;"
    cursor.execute(sql, (email, senha))
    usuario = cursor.fetchone()
    bd.close()

    if usuario:
        return jsonify({
            "code": 200,
            "id_usuario": usuario[0],
            "nome": usuario[1],
            "email": usuario[2],
            "tipo_usuario": usuario[3] 
        })
    return jsonify({"mensagem": "Credenciais incorretas.", "code": 401})

# RECUPERAÇÃO DE CONTA - PASSO 1: Retorna a pergunta cadastrada
@app.route('/recuperar/pergunta', methods=['POST'])
def buscar_pergunta():
    dados = request.get_json()
    email = dados['email']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "SELECT pergunta_seguranca FROM usuario WHERE email = %s;"
    cursor.execute(sql, (email,))
    resultado = cursor.fetchone()
    bd.close()

    if resultado:
        return jsonify({"pergunta_seguranca": resultado[0], "code": 200})
    return jsonify({"mensagem": "Email não encontrado.", "code": 404})

# RECUPERAÇÃO DE CONTA - PASSO 2: Valida a resposta e altera a senha
@app.route('/recuperar/senha', methods=['POST'])
def alterar_senha_recuperacao():
    dados = request.get_json()
    email = dados['email']
    resposta = dados['resposta_seguranca']
    nova_senha = dados['nova_senha']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "UPDATE usuario SET senha = %s WHERE email = %s AND resposta_seguranca = %s;"
    cursor.execute(sql, (nova_senha, email, resposta))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return jsonify({"mensagem": "Senha redefinida com sucesso!", "code": 200})
    return jsonify({"mensagem": "Resposta de segurança inválida.", "code": 400})

# ATUALIZAÇÃO DE PERFIL
@app.route('/perfil/atualizar', methods=['PUT'])
def atualizar_perfil():
    dados = request.get_json()
    id_usuario = dados['id_usuario']
    nome = dados['nome']
    senha = dados['senha']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "UPDATE usuario SET nome = %s, senha = %s WHERE id_usuario = %s;"
    cursor.execute(sql, (nome, senha, id_usuario))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return jsonify({"mensagem": "Dados do perfil atualizados!", "code": 200})
    return jsonify({"mensagem": "Nenhuma alteração foi realizada.", "code": 400})


##################### SELEÇÕES #############################

@app.route('/listaselecoes', methods=['GET'])
def consultaSelecoes():
    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "SELECT id_selecao, nome, grupo FROM selecao;"
    cursor.execute(sql)
    resultado = cursor.fetchall()
    
    selecoes = []
    for sel in resultado:
        selecoes.append({
            "idSelecao": sel[0],
            "nomeSelecao": sel[1],
            "grupoSelecao": sel[2]
        })
    bd.close()
    return jsonify(selecoes)

@app.route("/cadastraselecao", methods=["POST"])
def createSelecao():
    dados = request.get_json()
    nome = dados['nomeSelecao']
    grupo = dados['grupoSelecao']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "INSERT INTO selecao (nome, grupo) VALUES (%s, %s);"
    cursor.execute(sql, (nome, grupo))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()
    
    if resultado > 0:
        return jsonify({"mensagem": "Seleção cadastrada com sucesso!", "code": 200})
    return jsonify({"mensagem": "Erro ao cadastrar seleção.", "code": 400})

@app.route("/atualizaselecao", methods=['PUT'])
def updateSelecao():
    dados = request.get_json()
    id_selecao = dados['idSelecao'] 
    nome = dados['nomeSelecao']
    grupo = dados['grupoSelecao']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "UPDATE selecao SET nome = %s, grupo = %s WHERE id_selecao = %s;"
    cursor.execute(sql, (nome, grupo, id_selecao))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()
    
    if resultado > 0:
        return jsonify({"mensagem": "Seleção atualizada com sucesso!", "code": 200})
    return jsonify({"mensagem": "Seleção não localizada ou sem alterações.", "code": 400})

@app.route('/removeselecao', methods=['DELETE'])
def deleteSelecao():
    dados = request.get_json()
    id_selecao = dados['idSelecao']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "DELETE FROM selecao WHERE id_selecao = %s;"
    cursor.execute(sql, (id_selecao,))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return jsonify({"mensagem": "Seleção removida com sucesso!", "code": 200})
    return jsonify({"mensagem": "Seleção não localizada.", "code": 400})


##################### JOGADORES #############################

@app.route('/listajogadores', methods=['GET'])
def consultaJogadores():
    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "SELECT id_jogador, nome, posicao, id_selecao_fk FROM jogador;"
    cursor.execute(sql)
    resultado = cursor.fetchall()
    
    jogadores = []
    for jog in resultado:
        jogadores.append({
            "idJogador": jog[0],
            "nomeJogador": jog[1],
            "posicaoJogador": jog[2],
            "idSelecaoFk": jog[3]
        })
    bd.close()
    return jsonify(jogadores)

@app.route('/cadastrajogador', methods=['POST'])
def createJogador():
    dados = request.get_json()
    nome = dados['nomeJogador']
    posicao = dados['posicaoJogador']
    idSelecao = dados['idSelecaoFk']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "INSERT INTO jogador (nome, posicao, id_selecao_fk) VALUES (%s, %s, %s);"
    cursor.execute(sql, (nome, posicao, idSelecao))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return jsonify({"mensagem": "Jogador cadastrado com sucesso!", "code": 200})
    return jsonify({"mensagem": "Erro ao cadastrar jogador.", "code": 400})

@app.route("/atualizajogador", methods=['PUT'])
def updateJogador():
    dados = request.get_json()
    id_jogador = dados['idJogador']
    nome = dados['nomeJogador']
    posicao = dados['posicaoJogador']
    id_selecao_fk = dados['idSelecaoFk']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "UPDATE jogador SET nome = %s, posicao = %s, id_selecao_fk = %s WHERE id_jogador = %s;"
    cursor.execute(sql, (nome, posicao, id_selecao_fk, id_jogador))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()
    
    if resultado > 0:
        return jsonify({"mensagem": "Dados do jogador atualizados!", "code": 200})
    return jsonify({"mensagem": "Jogador não localizado ou sem alterações.", "code": 400})

@app.route('/removejogador', methods=['DELETE'])
def deleteJogador():
    dados = request.get_json()
    id_jogador = dados['idJogador']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "DELETE FROM jogador WHERE id_jogador = %s;"
    cursor.execute(sql, (id_jogador,))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return jsonify({"mensagem": "Jogador removido com sucesso!", "code": 200})
    return jsonify({"mensagem": "Jogador não localizado.", "code": 400})


########### PARTIDAS ##################

@app.route('/listapartidasdetalhada', methods=['GET'])
def consultaPartidasDetalhada():
    bd = conectaBanco()
    cursor = bd.cursor()
    sql = """SELECT p.id_partidas, p.data, s1.nome AS selecao_casa, s2.nome AS selecao_visitante, p.placar_casa, p.placar_visitante
            FROM partidas p
            JOIN selecao s1 ON p.id_selecao_casa_fk = s1.id_selecao
            JOIN selecao s2 ON p.id_selecao_visitante_fk = s2.id_selecao;"""
    cursor.execute(sql)
    resultado = cursor.fetchall()

    listaPartidas = []
    for part in resultado:
        listaPartidas.append({
            "idPartida": part[0],
            "dataPartida": str(part[1]),
            "selecaoCasa": part[2], 
            "selecaoVisitante": part[3], 
            "placarCasa": part[4], 
            "placarVisitante": part[5]
        })
    bd.close()
    return jsonify(listaPartidas)

@app.route("/cadastrapartida", methods=["POST"])
def createPartida():
    dados = request.get_json()
    data = dados['dataPartida']
    placarCasa = dados['placarSelecaoCasa']
    placarVisitante = dados['placarSelecaoVisitante']
    idSelecaoCasa = dados['idSelecaoCasa']
    idSelecaoVisitante = dados['idSelecaoVisitante']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "INSERT INTO partidas (data, placar_casa, placar_visitante, id_selecao_casa_fk, id_selecao_visitante_fk) VALUES (%s, %s, %s, %s, %s);"
    cursor.execute(sql, (data, placarCasa, placarVisitante, idSelecaoCasa, idSelecaoVisitante))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return jsonify({"mensagem": "Partida registrada com sucesso!", "code": 200})
    return jsonify({"mensagem": "Erro ao registrar partida.", "code": 400})

@app.route("/atualizapartida", methods=['PUT'])
def updatePartida():
    dados = request.get_json()
    id_partida = dados['idPartida']
    dataPartida = dados['dataPartida']
    placarCasa = dados['placarSelecaoCasa']
    placarVisitante = dados['placarSelecaoVisitante']
    idSelecaoCasa = dados['idSelecaoCasa']
    idSelecaoVisitante = dados['idSelecaoVisitante']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = """UPDATE partidas SET data = %s, placar_casa = %s, placar_visitante = %s, id_selecao_casa_fk = %s, id_selecao_visitante_fk = %s
            WHERE id_partidas = %s;"""
    cursor.execute(sql, (dataPartida, placarCasa, placarVisitante, idSelecaoCasa, idSelecaoVisitante, id_partida))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()
    
    if resultado > 0:
        return jsonify({"mensagem": "Partida atualizada com sucesso!", "code": 200})
    return jsonify({"mensagem": "Partida não localizada ou sem alterações.", "code": 400})

@app.route('/removepartida', methods=['DELETE'])
def deletePartida():
    dados = request.get_json()
    id_partida = dados['idPartida']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "DELETE FROM partidas WHERE id_partidas = %s;"
    cursor.execute(sql, (id_partida,))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return jsonify({"mensagem": "Partida removida com sucesso!", "code": 200})
    return jsonify({"mensagem": "Partida não localizada.", "code": 400})


##################### CHAVEAMENTO & FASES #############################

@app.route('/listafases', methods=['GET'])
def consultaFases():
    return jsonify([
        {"fase_id": 1, "nome_fase": "Fase de Grupos", "descricao": "12 grupos. Classificam-se os dois melhores e os oito melhores terceiros."},
        {"fase_id": 2, "nome_fase": "Dezesseis-avos de Final", "descricao": "Primeira eliminatória com 32 seleções em jogo único."},
        {"fase_id": 3, "nome_fase": "Oitavas de Final", "descricao": "16 vencedores seguem no chaveamento."},
        {"fase_id": 4, "nome_fase": "Quartas de Final", "descricao": "8 seleções disputam vaga nas semifinais."},
        {"fase_id": 5, "nome_fase": "Semifinal", "descricao": "4 seleções disputam vaga na final."},
        {"fase_id": 6, "nome_fase": "Disputa do 3º Lugar", "descricao": "Partida entre os derrotados nas semifinais."},
        {"fase_id": 7, "nome_fase": "Final", "descricao": "Partida decisiva para definição do campeão."}
    ])

@app.route('/listachaveamento', methods=['GET'])
def consultaChaveamento():
    return jsonify([
        "2A x 2B", "1E x 3A/B/C/D/F", "1F x 2C", "1C x 2F",
        "1I x 3C/D/F/G/H", "2E x 2I", "1A x 3C/E/F/H/I",
        "1L x 3E/H/I/J/K", "1D x 3B/E/F/I/J", "1G x 3A/E/H/I/J",
        "2K x 2L", "1H x 2J", "1B x 3E/F/G/I/J", "1J x 2H",
        "1K x 3D/E/I/J/L", "2D x 2G"
    ])

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")