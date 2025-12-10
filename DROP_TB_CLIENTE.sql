-- Remove o Trigger BEFORE UPDATE (se foi criado)
DROP TRIGGER TRG_CLIENTE_BU;

-- Remove o Trigger BEFORE INSERT (para popular ID e DT_CRIACAO)
DROP TRIGGER TRG_CLIENTE_BI;

-- Remove a Sequence que alimenta o ID_CLIENTE
DROP SEQUENCE SEQ_CLIENTE;

-- Remove a Tabela TB_CLIENTE
-- A cláusula CASCADE CONSTRAINTS garante que quaisquer chaves estrangeiras 
-- em outras tabelas que referenciem TB_CLIENTE sejam removidas, evitando erros.
DROP TABLE TB_CLIENTE CASCADE CONSTRAINTS;