package com.financas.app_financeiro.controller;

import com.financas.app_financeiro.model.DashboardDTO;
import com.financas.app_financeiro.model.Transacao;
import com.financas.app_financeiro.model.TipoTransacao;
import com.financas.app_financeiro.repository.TransacaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.math.BigDecimal;

@RestController
@RequestMapping("/transacoes")

public class TransacaoController {
  
  @Autowired
  private TransacaoRepository transacaoRepository;

  // 1. GET: Para ver o extrato
    @GetMapping
    public List<Transacao> listar() {
        return transacaoRepository.findAll();
    }

    // 2. POST: Para adicionar uma nova despesa ou receita
    @PostMapping
    public Transacao criar(@RequestBody Transacao transacao) {
        return transacaoRepository.save(transacao);
    }

    @GetMapping("/dashboard/{idUsuario}")
        public DashboardDTO getDashboard(@PathVariable Long idUsuario) {
            
            // Pede ao banco a soma das Receitas
            BigDecimal receitas = transacaoRepository.calcularTotal(idUsuario, TipoTransacao.RECEITA);
            
            // Pede ao banco a soma das Despesas
            BigDecimal despesas = transacaoRepository.calcularTotal(idUsuario, TipoTransacao.DESPESA);
            
            // Cria o objeto com os resultados e retorna
            return new DashboardDTO(receitas, despesas);
        }
}

