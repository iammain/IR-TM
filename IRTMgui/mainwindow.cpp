#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "QProcess"
#include "string"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);


}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
        QProcess p;
        QString program = "perl C:/workspace/IR-TM/Extraction/Scripts/coreference.pl C:/workspace/IR-TM/Extraction/Scripts/coreference.pl";
        p.execute(program);
}
