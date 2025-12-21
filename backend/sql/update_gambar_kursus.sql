
UPDATE kursus 
SET gambar_thumbnail = 'assets/images/Gemini_Generated_Image_ymnun9ymnun9ymnu.png' 
WHERE id = 2;

UPDATE kursus 
SET gambar_thumbnail = 'assets/images/pengnalan_qc.png' 
WHERE id = 1;


SELECT id, judul, gambar_thumbnail FROM kursus WHERE id IN (1, 2);
