settings.outformat = "pdf";
size(10cm);
Label B1 = Label("$B_1$", position=Relative(0.9));
Label B2 = Label("$B_2$", position=Relative(0.9));
Label B3 = Label("$B_3$", position=Relative(0.8));
label("$x$", (1.3, 1), align=W);
draw(circle((0, 0), 2.1), L=B1);
draw(circle((2, 1), 1.2), L=B2);
draw(circle((1.3, 1), 0.4), L=B3);
dot((1.3, 1));