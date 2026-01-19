package com.medicalcare.audit.controller;

import com.medicalcare.audit.entity.AuditLog;
import com.medicalcare.audit.service.AuditService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/")
public class WebController {

    @Autowired
    private AuditService auditService;

    @GetMapping("/audit")
    public String audit(Model model) {
        List<AuditLog> auditLogs = auditService.getAllAuditLogs();
        model.addAttribute("auditLogs", auditLogs);
        return "audit";
    }
}
