% dronethebit third assignment
img_rgb = imread('IM1.jpg');
img_hsv = rgb2hsv(img_rgb);
img_hsv_h = img_hsv(:,:,1);
img_hsv_s = img_hsv(:,:,2);
img_hsv_v = img_hsv(:,:,3); 

hsv_green = double(zeros(size(img_hsv_h))); 

for i = 1: size(hsv_green, 1)

    for j = 1:size(hsv_green, 2)

        if (img_hsv_h(i, j) > 0.3 && img_hsv_h(i, j) < 0.4) && (img_hsv_v(i, j) < 0.97) && (img_hsv_s(i,j) > 0.4)
             hsv_green(i, j) = 1;

        end

    end

end