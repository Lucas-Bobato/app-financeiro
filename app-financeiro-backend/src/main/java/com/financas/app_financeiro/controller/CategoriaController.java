package com.financas.app_financeiro.controller;

import com.financas.app_financeiro.model.Categoria;
import com.financas.app_financeiro.repository.CategoriaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/categorias")
public class CategoriaController {

    @Autowired
    private CategoriaRepository categoriaRepository;

    // Listar todas as categorias
    @GetMapping
    public List<Categoria> listar() {
        return categoriaRepository.findAll();
    }
    
    // Listar categorias de um usuário (incluindo as padrões)
    @GetMapping("/usuario/{usuarioId}")
    public List<Categoria> listarPorUsuario(@PathVariable Long usuarioId) {
        List<Categoria> categorias = new ArrayList<>();
        // Adiciona categorias padrão do sistema
        categorias.addAll(categoriaRepository.findByUsuarioIsNull());
        // Adiciona categorias personalizadas do usuário
        categorias.addAll(categoriaRepository.findByUsuarioId(usuarioId));
        return categorias;
    }

    // Criar nova categoria
    @PostMapping
    public Categoria criar(@RequestBody Categoria categoria) {
        // Dica: Se enviares o JSON sem "usuario", o campo id_usuario ficará null.
        // Isso significa que será uma "Categoria Padrão" do sistema.
        return categoriaRepository.save(categoria);
    }
    
    // Deletar categoria
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletar(@PathVariable Long id) {
        if (categoriaRepository.existsById(id)) {
            categoriaRepository.deleteById(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}