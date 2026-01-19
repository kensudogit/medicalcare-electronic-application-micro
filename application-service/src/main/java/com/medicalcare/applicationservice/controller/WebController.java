package com.medicalcare.applicationservice.controller;

import com.medicalcare.applicationservice.domain.Application;
import com.medicalcare.applicationservice.service.ApplicationService;
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
    private ApplicationService applicationService;

    @GetMapping("/applications")
    public String applications(Model model) {
        List<Application> applications = applicationService.findAll();
        model.addAttribute("applications", applications);
        return "applications";
    }
}
