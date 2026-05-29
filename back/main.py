
import os
from flask import Flask, jsonify, request
from flask_cors import CORS 
import pymysql
from dotenv import load_dotenv

load_dotenv()
"""Ponto de entrada do backend: cria o app e inicia o servidor Flask."""

from app import create_app


def conectaBanco():
    return pymysql.connect(
        database=os.getenv('DB_NAME', 'copado_mundo'),
        host=os.getenv('DB_HOST', 'localhost'),
        user=os.getenv('DB_USER', 'root'),
        passwd=os.getenv('DB_PASSWORD', os.getenv('MYSQL_PASSWORD', 'Mimo2007!')),
        port=int(os.getenv('DB_PORT', 3306)),
        charset='utf8mb4'
    )


@app.route('/cadastro', methods=['POST'])
def cadastro():
    dados = request.get_json()
    nome = dados['nome']
    email = dados['email']
    senha = dados['senha']
    pergunta = dados['pergunta_seguranca']
    resposta = dados['resposta_seguranca']

    bd = conectaBanco()
    cursor = bd.cursor()
    try:
        sql = "INSERT INTO usuario (nome, email, senha, pergunta_seguranca, resposta_seguranca) VALUES (%s, %s, %s, %s, %s);"
        cursor.execute(sql, (nome, email, senha, pergunta, resposta))
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
    sql = "SELECT id_usuario, nome, email FROM usuario WHERE email = %s AND senha = %s;"
    cursor.execute(sql, (email, senha))
    usuario = cursor.fetchone()
    bd.close()

    if usuario:
        return jsonify({
            "code": 200,
            "id_usuario": usuario[0],
            "nome": usuario[1],
            "email": usuario[2]
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
@app.route('/recuperar/validar', methods=['POST'])
def validar_recuperacao():
    dados = request.get_json()
    email = dados['email']
    pergunta = dados['pergunta_seguranca']
    resposta = dados['resposta_seguranca']

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = """SELECT id_usuario FROM usuario
             WHERE email = %s
             AND pergunta_seguranca = %s
             AND resposta_seguranca = %s;"""
    cursor.execute(sql, (email, pergunta, resposta))
    resultado = cursor.fetchone()
    bd.close()

    if resultado:
        return jsonify({"mensagem": "Dados de recuperacao confirmados.", "code": 200})
    return jsonify({"mensagem": "Email ou resposta de seguranca invalidos.", "code": 400})

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

##################### SELEÇÕES (EQUIPES) #############################

@app.route('/listaequipes', methods=['GET'])
@app.route('/listaselecoes', methods=['GET'])
def consultaSelecoes():
    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "SELECT id_selecao, nome, grupo FROM selecao WHERE acompanhar = 1;"
    cursor.execute(sql)
    resultado = cursor.fetchall()
    
    selecoes = []
    for sel in resultado:
        selecoes.append({
            "idSelecao": sel[0],
            "nomeSelecao": sel[1],
            "grupoSelecao": sel[2],
            "idTime": sel[0],
            "nome": sel[1],
            "cidade": sel[2]  # Flutter mapeia cidade para o grupo do banco
        })
    bd.close()
    return jsonify(selecoes)

@app.route("/cadastraequipe", methods=["POST"])
@app.route("/cadastraselecao", methods=["POST"])
def createSelecao():
    dados = request.get_json() or {}
    nome = dados.get('nomeEquipe') or dados.get('nomeSelecao')
    grupo = dados.get('cidadeEquipe') or dados.get('grupoSelecao')

    bd = conectaBanco()
    cursor = bd.cursor()
    
    # Verifica se a seleção já existe no banco (pré-cadastrada ou não)
    cursor.execute("SELECT id_selecao FROM selecao WHERE nome = %s;", (nome,))
    existe = cursor.fetchone()
    
    if existe:
        # Se existe, apenas marcamos para acompanhar
        sql = "UPDATE selecao SET acompanhar = 1, grupo = %s WHERE id_selecao = %s;"
        cursor.execute(sql, (grupo, existe[0]))
    else:
        # Se não existe por algum motivo, inserimos como acompanhada
        sql = "INSERT INTO selecao (nome, grupo, acompanhar) VALUES (%s, %s, 1);"
        cursor.execute(sql, (nome, grupo))
        
    bd.commit()
    resultado = cursor.rowcount
    bd.close()
    
    if resultado > 0:
        return jsonify({"mensagem": "Seleção cadastrada com sucesso!", "code": 200})
    return jsonify({"mensagem": "Erro ao cadastrar seleção.", "code": 400})

@app.route("/atualizaequipe", methods=['PUT'])
@app.route("/atualizaselecao", methods=['PUT'])
def updateSelecao():
    dados = request.get_json() or {}
    id_selecao = dados.get('idEquipe') or dados.get('idSelecao')
    nome = dados.get('nomeEquipe') or dados.get('nomeSelecao')
    grupo = dados.get('cidadeEquipe') or dados.get('grupoSelecao')

    bd = conectaBanco()
    cursor = bd.cursor()
    
    # Descobre o nome da seleção que estava sendo editada anteriormente
    cursor.execute("SELECT nome FROM selecao WHERE id_selecao = %s;", (id_selecao,))
    old_team = cursor.fetchone()
    
    resultado = 0
    if old_team and old_team[0] != nome:
        # O usuário está alterando o país selecionado!
        # 1. Deixa de acompanhar o antigo
        cursor.execute("UPDATE selecao SET acompanhar = 0 WHERE id_selecao = %s;", (id_selecao,))
        # 2. Passa a acompanhar o novo (verifica se o novo já existe)
        cursor.execute("SELECT id_selecao FROM selecao WHERE nome = %s;", (nome,))
        novo_existe = cursor.fetchone()
        if novo_existe:
            cursor.execute("UPDATE selecao SET acompanhar = 1, grupo = %s WHERE id_selecao = %s;", (grupo, novo_existe[0]))
        else:
            cursor.execute("INSERT INTO selecao (nome, grupo, acompanhar) VALUES (%s, %s, 1);", (nome, grupo))
        resultado = 1
    else:
        # O nome é o mesmo, apenas atualiza grupo se necessário
        cursor.execute("UPDATE selecao SET grupo = %s WHERE id_selecao = %s;", (grupo, id_selecao))
        resultado = cursor.rowcount
        
    bd.commit()
    bd.close()
    
    if resultado > 0:
        return jsonify({"mensagem": "Seleção atualizada com sucesso!", "code": 200})
    return jsonify({"mensagem": "Seleção não localizada ou sem alterações.", "code": 400})

@app.route('/removeequipe', methods=['DELETE'])
@app.route('/removeselecao', methods=['DELETE'])
def deleteSelecao():
    dados = request.get_json() or {}
    id_selecao = dados.get('idEquipe') or dados.get('idSelecao')

    bd = conectaBanco()
    cursor = bd.cursor()
    # Em vez de deletar de fato do banco (o que violaria chaves estrangeiras de jogadores e partidas),
    # nós apenas deixamos de acompanhar aquela seleção.
    sql = "UPDATE selecao SET acompanhar = 0 WHERE id_selecao = %s;"
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
    id_selecao = request.args.get('idSelecao')
    
    bd = conectaBanco()
    cursor = bd.cursor()
    
    if id_selecao:
        # Retorna todos os jogadores daquela seleção para poder selecionar no dropdown da UI
        sql = """SELECT j.id_jogador, j.nome, j.posicao, j.id_selecao_fk, s.nome 
                 FROM jogador j
                 JOIN selecao s ON j.id_selecao_fk = s.id_selecao
                 WHERE j.id_selecao_fk = %s;"""
        cursor.execute(sql, (id_selecao,))
    else:
        # Retorna apenas os jogadores marcados para acompanhar
        sql = """SELECT j.id_jogador, j.nome, j.posicao, j.id_selecao_fk, s.nome 
                 FROM jogador j
                 JOIN selecao s ON j.id_selecao_fk = s.id_selecao
                 WHERE j.acompanhar = 1;"""
        cursor.execute(sql)
        
    resultado = cursor.fetchall()
    
    jogadores = []
    for jog in resultado:
        jogadores.append({
            "idJogador": jog[0],
            "nomeJogador": jog[1],
            "posicaoJogador": jog[2],
            "idSelecaoFk": jog[3],
            "idTimeFk": jog[3],  # Flutter espera idTimeFk
            "nomeSelecao": jog[4]  # Envia o nome do país/seleção para o Flutter
        })
    bd.close()
    return jsonify(jogadores)

@app.route('/cadastrajogador', methods=['POST'])
def createJogador():
    dados = request.get_json() or {}
    nome = dados.get('nomeJogador')
    posicao = dados.get('posicaoJogador')
    idSelecao = dados.get('idTimeFk') or dados.get('idSelecaoFk')

    bd = conectaBanco()
    cursor = bd.cursor()
    
    # Verifica se o jogador já existe na seleção
    cursor.execute("SELECT id_jogador FROM jogador WHERE nome = %s AND id_selecao_fk = %s;", (nome, idSelecao))
    existe = cursor.fetchone()
    
    if existe:
        # Apenas ativa o acompanhamento e atualiza a posição se enviada
        sql = "UPDATE jogador SET acompanhar = 1, posicao = %s WHERE id_jogador = %s;"
        cursor.execute(sql, (posicao, existe[0]))
    else:
        # Cria um novo jogador se não existir
        sql = "INSERT INTO jogador (nome, posicao, id_selecao_fk, acompanhar) VALUES (%s, %s, %s, 1);"
        cursor.execute(sql, (nome, posicao, idSelecao))
        
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        # Retorna 200 para compatibilidade com o front-end que espera 200 para sucesso
        return jsonify({"mensagem": "Jogador cadastrado para acompanhar com sucesso!", "code": 200})
    return jsonify({"mensagem": "Erro ao cadastrar jogador.", "code": 400})

@app.route("/atualizajogador", methods=['PUT'])
def updateJogador():
    dados = request.get_json() or {}
    id_jogador = dados.get('idJogador')
    nome = dados.get('nomeJogador')
    posicao = dados.get('posicaoJogador')
    id_selecao_fk = dados.get('idTimeFk') or dados.get('idSelecaoFk')

    bd = conectaBanco()
    cursor = bd.cursor()
    
    sql = "UPDATE jogador SET nome = %s, posicao = %s, id_selecao_fk = %s, acompanhar = 1 WHERE id_jogador = %s;"
    cursor.execute(sql, (nome, posicao, id_selecao_fk, id_jogador))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()
    
    if resultado > 0:
        return jsonify({"mensagem": "Dados do jogador atualizados!", "code": 200})
    return jsonify({"mensagem": "Jogador não localizado ou sem alterações.", "code": 400})

@app.route('/removejogador', methods=['DELETE'])
def deleteJogador():
    dados = request.get_json() or {}
    id_jogador = dados.get('idJogador')

    bd = conectaBanco()
    cursor = bd.cursor()
    # Em vez de deletar fisicamente, apenas deixa de acompanhar
    sql = "UPDATE jogador SET acompanhar = 0 WHERE id_jogador = %s;"
    cursor.execute(sql, (id_jogador,))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return jsonify({"mensagem": "Jogador removido do acompanhamento!", "code": 200})
    return jsonify({"mensagem": "Jogador não localizado.", "code": 400})


########### PARTIDAS ##################

@app.route('/listapartidas', methods=['GET'])
@app.route('/listapartidasdetalhada', methods=['GET'])
def consultaPartidasDetalhada():
    bd = conectaBanco()
    cursor = bd.cursor()
    sql = """SELECT p.id_partidas, p.data, s1.nome AS selecao_casa, s2.nome AS selecao_visitante, p.placar_casa, p.placar_visitante,
                    p.id_selecao_casa_fk, p.id_selecao_visitante_fk
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
            "placarVisitante": part[5],
            "placarEquipeCasa": part[4],
            "placarEquipeVisitante": part[5],
            "idEquipeCasa": part[6],
            "idEquipeVisitante": part[7]
        })
    bd.close()
    return jsonify(listaPartidas)

@app.route("/cadastrapartida", methods=["POST"])
def createPartida():
    dados = request.get_json()
    data = dados['dataPartida']
    placarCasa = dados.get('placarEquipeCasa') if dados.get('placarEquipeCasa') is not None else dados.get('placarSelecaoCasa')
    placarVisitante = dados.get('placarEquipeVisitante') if dados.get('placarEquipeVisitante') is not None else dados.get('placarSelecaoVisitante')
    idSelecaoCasa = dados.get('idEquipeCasa') or dados.get('idSelecaoCasa')
    idSelecaoVisitante = dados.get('idEquipeVisitante') or dados.get('idSelecaoVisitante')

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
    placarCasa = dados.get('placarEquipeCasa') if dados.get('placarEquipeCasa') is not None else dados.get('placarSelecaoCasa')
    placarVisitante = dados.get('placarEquipeVisitante') if dados.get('placarEquipeVisitante') is not None else dados.get('placarSelecaoVisitante')
    idSelecaoCasa = dados.get('idEquipeCasa') or dados.get('idSelecaoCasa')
    idSelecaoVisitante = dados.get('idEquipeVisitante') or dados.get('idSelecaoVisitante')

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

app = create_app()


if __name__ == "__main__":
    app.run(debug=True)
