package by.teachmeskills.eshop.services.impl;

import by.teachmeskills.eshop.entities.Image;
import by.teachmeskills.eshop.exceptions.ImageException;
import by.teachmeskills.eshop.repositories.ImageRepository;
import by.teachmeskills.eshop.services.ImageService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ImageServiceImpl implements ImageService {
    private final ImageRepository imageRepository;

    public ImageServiceImpl(ImageRepository imageRepository) {
        this.imageRepository = imageRepository;
    }

    @Override
    public Image create(Image entity) {
        return imageRepository.save(entity);
    }

    @Override
    public List<Image> read() {
        return imageRepository.findAll();
    }

    @Override
    public Image update(Image entity) throws ImageException {
        Optional<Image> image = imageRepository.findById(entity.getId());
        if (image.isPresent()) {
            return imageRepository.save(entity);
        } else {
            throw new ImageException("Image doesn't exist in the DB");
        }
    }

    @Override
    public void delete(int id) {
        imageRepository.deleteById(id);
    }
}
