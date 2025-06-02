#install.packages('hexSticker')
#devtools::install_github("doehm/eyedroppeR")
library(hexSticker)
library(eyedroppeR)

rayyanapplogo<-magick::image_read("graphics/rayyanlogo.png")
rayyanlightpurple<-eyedroppeR::eyedropper(n=1, img_path = "graphics/rayyanlogo.png")
rayyandarkpurple<-eyedroppeR::eyedropper(n=1, img_path = "graphics/rayyanlogo_dark.png")

s <- hexSticker::sticker(rayyanapplogo, 
                         h_fill=rayyanlightpurple$pal, h_color=rayyandarkpurple$pal, h_size=5,
                         package="", p_size=10,  s_x=1, s_y=1, s_width=5, s_height=1.5,
                         white_around_sticker = T,
                         filename = "graphics/hexsticker_app1.png",
                         url='Rayyan is a trademark of Rayyan Systems, Inc. www.rayyan.com', 
                         u_size=2.7, u_color = 'white', u_x = 1, u_y = 0.04)
s

s <- hexSticker::sticker(rayyanapplogo, 
                         h_fill=rayyanlightpurple$pal, h_color=rayyandarkpurple$pal, h_size=3,
                         package="", p_size=10,  s_x=1, s_y=1, s_width=5, s_height=1.5,
                         white_around_sticker = T,
                         filename = "graphics/hexsticker_app2.png",
                         url='Rayyan is a trademark of Rayyan Systems, Inc. www.rayyan.com', 
                         u_size=2.7, u_color = 'white', u_x = 1, u_y = 0.025)
s

rayyanweblogo<-magick::image_read("graphics/rayyanlogo_dark_cropped.png")
s <- hexSticker::sticker(rayyanweblogo, h_fill=rayyandarkpurple$pal, h_color=rayyandarkpurple$pal,
                         package="R", p_size=30,  p_x=1.6, p_y=1.03,
                         s_x=0.875, s_y=1, s_width=1.2, s_height=1.5,
                         filename = "graphics/hexsticker_web1.png",
                         url='Rayyan is a trademark of Rayyan Systems, Inc. www.rayyan.com', 
                         u_size=2.7, u_color = 'white', u_x = 1, u_y = 0.1)
s


s <- hexSticker::sticker(rayyanweblogo, h_fill=rayyandarkpurple$pal, h_color=rayyandarkpurple$pal,
                         package="R", p_size=30,  p_x=1.6, p_y=1.07,
                         s_x=0.875, s_y=1, s_width=1.2, s_height=1.5,
                         filename = "graphics/hexsticker_web2.png", 
                         url='Rayyan is a trademark of Rayyan Systems, Inc. www.rayyan.com', 
                         u_size=2.7, u_color = 'white', u_x = 1, u_y = 0.035)
s

