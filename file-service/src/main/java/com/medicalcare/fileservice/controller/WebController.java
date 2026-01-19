package com.medicalcare.fileservice.controller;

import com.medicalcare.fileservice.domain.FileRecord;
import com.medicalcare.fileservice.service.FileService;
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
    private FileService fileService;

    @GetMapping("/files")
    public String files(Model model) {
        List<FileRecord> files = fileService.findAll();
        model.addAttribute("files", files);
        return "files";
    }
}
