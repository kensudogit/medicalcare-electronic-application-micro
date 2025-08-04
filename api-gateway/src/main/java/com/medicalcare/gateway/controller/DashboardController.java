package com.medicalcare.gateway.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * ダッシュボードコントローラー
 * ログイン後のメインページを提供
 */
@Controller
public class DashboardController {

    /**
     * ダッシュボードページ
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("title", "医療系電子申請システム - ダッシュボード");
        return "dashboard";
    }

    /**
     * ログインページ
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }

    /**
     * ルートページ（ダッシュボードにリダイレクト）
     */
    @GetMapping("/")
    public String root() {
        return "redirect:/dashboard";
    }
}