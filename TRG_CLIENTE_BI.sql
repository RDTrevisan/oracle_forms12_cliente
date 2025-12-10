CREATE OR REPLACE TRIGGER TRG_CLIENTE_BI
BEFORE INSERT ON TB_CLIENTE
FOR EACH ROW
BEGIN
    -- 1. Popula ID_CLIENTE com o próximo valor da sequence
    :NEW.ID_CLIENTE := SEQ_CLIENTE.NEXTVAL;
    
    -- 2. Popula DT_CRIACAO com a data e hora atual do sistema
    :NEW.DT_CRIACAO := SYSDATE;
    
    -- Nota: Se a coluna DT_ATUALIZACAO for usada, você pode configurá-la
    -- aqui para ser preenchida também na inserção, se necessário.
    -- Exemplo: :NEW.DT_ATUALIZACAO := SYSDATE;
END;
/
