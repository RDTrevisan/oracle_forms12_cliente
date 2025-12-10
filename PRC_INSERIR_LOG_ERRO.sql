CREATE OR REPLACE PROCEDURE PRC_INSERIR_LOG_ERRO (
    p_usuario     IN TB_LOG_ERRO.USUARIO%TYPE,
    p_origem      IN TB_LOG_ERRO.ORIGEM%TYPE,
    p_mensagem    IN TB_LOG_ERRO.MENSAGEM%TYPE,
    p_codigo_erro IN TB_LOG_ERRO.CODIGO_ERRO%TYPE DEFAULT NULL
)
AS
    -- Declaração obrigatória para transações independentes
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO TB_LOG_ERRO (
        DT_EVENTO,
        USUARIO,
        ORIGEM,
        MENSAGEM,
        CODIGO_ERRO
    )
    VALUES (
        SYSDATE, -- Usa a data atual do sistema
        p_usuario,
        p_origem,
        p_mensagem,
        p_codigo_erro
    );
    
    -- Confirma a inserção do log, garantindo que seja salvo 
    -- mesmo que o Forms ou o código chamador dê rollback.
    COMMIT; 
    
EXCEPTION
    -- Se houver falha ao inserir o log (ex: mensagem muito longa), faz um rollback
    -- autônomo e não propaga a exceção.
    WHEN OTHERS THEN
        NULL;
        -- Opcional: registrar em arquivo de log de servidor se a falha do log for crítica.
END PRC_INSERIR_LOG_ERRO;
/
