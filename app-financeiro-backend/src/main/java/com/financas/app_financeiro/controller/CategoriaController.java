package com.financas.app_financeiro.controller;

import com.financas.app_financeiro.model.Categoria;
import com.financas.app_financeiro.repository.CategoriaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/categorias")
public class CategoriaController {

    @Autowired
    private CategoriaRepository categoriaRepository;

    @GetMapping
    public List<Categoria> listar() {
        return categoriaRepository.findAll();
    }

    @PostMapping
    public Categoria criar(@RequestBody Categoria categoria) {
        // Dica: Se enviares o JSON sem "usuario", o campo id_usuario ficará null.
        // Isso significa que será uma "Categoria Padrão" do sistema.
        return categoriaRepository.save(categoria);
    }
}