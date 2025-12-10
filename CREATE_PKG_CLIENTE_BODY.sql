CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY PKG_CLIENTE AS
    
    --------------------------------------------------------------------------------
    -- FUNCTION: FN_VALIDAR_EMAIL
    -- Retorna 1 se válido, 0 se inválido.
    --------------------------------------------------------------------------------
    FUNCTION FN_VALIDAR_EMAIL (p_email VARCHAR2) RETURN NUMBER IS
        v_valid NUMBER;
    BEGIN
        -- Expressão regular básica para validar formato de email
        SELECT CASE WHEN REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')
               THEN 1 ELSE 0 END INTO v_valid
        FROM DUAL;

        RETURN v_valid;
    END FN_VALIDAR_EMAIL;

    --------------------------------------------------------------------------------
    -- FUNCTION: FN_NORMALIZAR_CEP
    -- Retorna CEP com 8 dígitos, somente números.
    --------------------------------------------------------------------------------
    FUNCTION FN_NORMALIZAR_CEP (p_cep VARCHAR2) RETURN VARCHAR2 IS
        v_cep_normalizado VARCHAR2(8);
    BEGIN
        -- Remove todos os caracteres que não são dígitos
        v_cep_normalizado := REGEXP_REPLACE(p_cep, '[^0-9]', '');

        RETURN v_cep_normalizado;
    END FN_NORMALIZAR_CEP;

    --------------------------------------------------------------------------------
    -- PROCEDURE: PRC_DELETAR_CLIENTE
    --------------------------------------------------------------------------------
    PROCEDURE PRC_DELETAR_CLIENTE (p_id NUMBER) IS
        v_count NUMBER;
    BEGIN
        DELETE FROM TB_CLIENTE
        WHERE ID_CLIENTE = p_id;

        v_count := SQL%ROWCOUNT;

        -- Validação de existência
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(ERRO_CLIENTE_NAO_ENCONTRADO, 'O cliente ID ' || p_id || ' não foi encontrado para exclusão.');
        END IF;

        -- Não há COMMIT/ROLLBACK aqui.
    END PRC_DELETAR_CLIENTE;

    --------------------------------------------------------------------------------
    -- PROCEDURE: PRC_LISTAR_CLIENTES
    --------------------------------------------------------------------------------
    PROCEDURE PRC_LISTAR_CLIENTES(p_nome  VARCHAR2,
                                  p_email VARCHAR2,
                                  p_rc    IN OUT T_CLIENTES_RC) IS
      v_count NUMBER;
    BEGIN
      -- 1. Contar os registros com base nos filtros (para a validação de lista vazia)
      SELECT COUNT(*)
        INTO v_count
        FROM TB_CLIENTE
       WHERE (p_nome IS NULL OR
             UPPER(NOME) LIKE '%' || UPPER(p_nome) || '%') -- Filtro Dinâmico para NOME (busca parcial)
         AND (p_email IS NULL OR UPPER(EMAIL) = UPPER(p_email)) 
         ORDER BY NOME; -- Filtro Dinâmico para EMAIL (busca exata)
    
      -- 2. Validação: Se a contagem for zero, levanta o erro personalizado
      IF v_count = 0 THEN
        -- ERRO_LISTA_VAZIA deve estar definido no Package Specification
        RAISE_APPLICATION_ERROR(ERRO_CLIENTE_NAO_ENCONTRADO,
                                'Nenhum cliente encontrado com os critérios de filtro informados.');
      END IF;
    
      -- 3. Abrir o cursor (somente se a contagem for maior que zero)
      OPEN p_rc FOR
      -- Selecionando todas as colunas explicitamente
        SELECT ID_CLIENTE,
               NOME,
               EMAIL,
               CEP,
               LOGRADOURO,
               BAIRRO,
               CIDADE,
               UF,
               ATIVO,
               DT_CRIACAO,
               DT_ATUALIZACAO
          FROM TB_CLIENTE
         WHERE (p_nome IS NULL OR
               UPPER(NOME) LIKE '%' || UPPER(p_nome) || '%')
           AND (p_email IS NULL OR UPPER(EMAIL) = UPPER(p_email))
         ORDER BY NOME;
    
    END PRC_LISTAR_CLIENTES;
    
END PKG_CLIENTE;
