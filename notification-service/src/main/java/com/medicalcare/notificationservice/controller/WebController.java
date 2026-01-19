package com.medicalcare.notificationservice.controller;

import com.medicalcare.notificationservice.domain.Notification;
import com.medicalcare.notificationservice.service.NotificationService;
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
    private NotificationService notificationService;

    @GetMapping("/notifications")
    public String notifications(Model model) {
        List<Notification> notifications = notificationService.findAll();
        model.addAttribute("notifications", notifications);
        return "notifications";
    }
}
