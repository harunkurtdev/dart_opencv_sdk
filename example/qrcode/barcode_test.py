import cv2
import numpy as np


def generate_barcode(barcode_data, size=256):
    barcode = np.ones((size, size, 3), dtype=np.uint8) * 255

    barcode_size = size // (len(barcode_data) + 6)
    margin_size = barcode_size // 2
    gap_size = margin_size // 2
    
    # Başlangıç işareti (beginning)
    barcode[:margin_size, :margin_size] = 0
    
    # Sol kod (left code)
    for i in range(margin_size):
        barcode[margin_size:margin_size*2, i] = 0
    
    # Üst kenar boşluğu
    barcode[:margin_size, margin_size:-margin_size] = 255
    
    # Orta kısım (middle)
    for i, num in enumerate(barcode_data):
        if num == 1:
            x = (i % barcode_size) * barcode_size + margin_size * 2
            for j in range(barcode_size):
                y = ((i // barcode_size) + j) * barcode_size + margin_size * 2
                barcode[y:y-barcode_size, x:x+barcode_size-gap_size] = 0
                
            # Çubuklar arası boşluk
            x_end = x + barcode_size - gap_size
            barcode[y:y-barcode_size, x_end:x_end+gap_size] = 255
        else:
            # Boş veri alanı
            x = (i % barcode_size) * barcode_size + margin_size * 2
            y = ((i // barcode_size) * barcode_size) + margin_size * 2
            barcode[y:y-barcode_size, x:x+barcode_size] = 255
    
    # Sağ kod (right code)
    for i in range(margin_size):
        x = (len(barcode_data) % barcode_size) * barcode_size + margin_size * 2 + barcode_size - i - 1
        barcode[margin_size:margin_size*2, x] = 0
    
    # Alt kenar boşluğu
    barcode[-margin_size:, margin_size:-margin_size] = 255
    
    # Son işareti (end mark)
    barcode[-margin_size:, -margin_size:] = 0
    
    return barcode

def save_barcode_image(barcode_img, file_path):
    cv2.imwrite(file_path, barcode_img)
    print('Barcode saved to:', file_path)
    
def convert_numeric_to_binary(num):
    binary_str = bin(num)[2:].zfill(4) 
    return binary_str



def convert_numeric_to_binary_list(num):
    binary_str = convert_numeric_to_binary(num)
    binary_list = [int(bit) for bit in binary_str]
    return binary_list


def main():
    barcode_data = int(input("Bir veri girin: "))  
    barcode_data = convert_numeric_to_binary_list(barcode_data) 
    print(barcode_data)
    barcode_img = generate_barcode(barcode_data, size=256)

    if barcode_img is not None:
        file_path = 'barcode.png'
        save_barcode_image(barcode_img, file_path)
    else:
        print('Failed to generate barcode.')

if __name__ == '__main__':
    main()
