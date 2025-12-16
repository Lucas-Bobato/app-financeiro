package com.financas.app_financeiro.repository;

import com.financas.app_financeiro.model.Transacao;
import com.financas.app_financeiro.model.TipoTransacao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface TransacaoRepository extends JpaRepository<Transacao, Long> {

  @Query("SELECT COALESCE(SUM(t.valor), 0) FROM Transacao t WHERE t.usuario.id = :userId AND t.tipo = :tipo")
    BigDecimal calcularTotal(@Param("userId") Long userId, @Param("tipo") TipoTransacao tipo);

    // Busca pelo ID do usuário e ordena pela Data (Decrescente: do mais novo pro mais velho)
    List<Transacao> findByUsuarioIdOrderByDataDesc(Long idUsuario);
}