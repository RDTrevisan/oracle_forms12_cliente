CREATE OR REPLACE NONEDITIONABLE PACKAGE PKG_CLIENTE AS

    -- Códigos de Erro (aplicados ao RAISE_APPLICATION_ERROR)
    ERRO_NOME_OBRIGATORIO CONSTANT NUMBER := -20001;
    ERRO_EMAIL_INVALIDO   CONSTANT NUMBER := -20002;
    ERRO_EMAIL_DUPLICADO  CONSTANT NUMBER := -20003;
    ERRO_CEP_INVALIDO     CONSTANT NUMBER := -20004;
    ERRO_UF_INVALIDA      CONSTANT NUMBER := -20005;
    ERRO_CLIENTE_NAO_ENCONTRADO CONSTANT NUMBER := -20006;

    -- Tipo de retorno para cursor (para PRC_LISTAR_CLIENTES)
    TYPE T_CLIENTES_RC IS REF CURSOR;

    -- Function para validar o formato do email
    FUNCTION FN_VALIDAR_EMAIL (p_email VARCHAR2) RETURN NUMBER;

    -- Function para normalizar o CEP (somente 8 dígitos)
    FUNCTION FN_NORMALIZAR_CEP (p_cep VARCHAR2) RETURN VARCHAR2;

    -- Procedure para deletar um cliente
    PROCEDURE PRC_DELETAR_CLIENTE (p_id NUMBER);

    -- Procedure para listar clientes com filtros opcionais
    PROCEDURE PRC_LISTAR_CLIENTES (
        p_nome  VARCHAR2,
        p_email VARCHAR2,
        p_rc    IN OUT T_CLIENTES_RC
    );    

END PKG_CLIENTE;