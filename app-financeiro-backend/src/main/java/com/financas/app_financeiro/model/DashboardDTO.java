package com.financas.app_financeiro.model;

import java.math.BigDecimal;

public class DashboardDTO {
    private BigDecimal totalReceitas;
    private BigDecimal totalDespesas;
    private BigDecimal saldo;

    // Construtor que já calcula o saldo
    public DashboardDTO(BigDecimal totalReceitas, BigDecimal totalDespesas) {
        this.totalReceitas = totalReceitas;
        this.totalDespesas = totalDespesas;
        this.saldo = totalReceitas.subtract(totalDespesas);
    }

    // Getters
    public BigDecimal getTotalReceitas() { return totalReceitas; }
    public BigDecimal getTotalDespesas() { return totalDespesas; }
    public BigDecimal getSaldo() { return saldo; }
}