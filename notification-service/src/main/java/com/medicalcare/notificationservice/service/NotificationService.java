package com.medicalcare.notificationservice.service;

import com.medicalcare.notificationservice.domain.Notification;
import com.medicalcare.notificationservice.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    public List<Notification> findAll() {
        return notificationRepository.findAll();
    }

    public List<Notification> findByUserId(Long userId) {
        return notificationRepository.findByUserId(userId);
    }

    public Notification save(Notification notification) {
        return notificationRepository.save(notification);
    }
}
