#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "QProcess"
#include "QFileDialog"

#include <QtGui>
#include <QGraphicsSceneMouseEvent>
#include <iostream>
#include <math.h>
#include <algorithm>
#include <fstream>
#include <string.h>
#include <QPainter>
#include <sstream>

using namespace std;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    statusBar()->showMessage("Please select the in- and output directories.");

    ui->RunStanford->setVisible(false);
    ui->RunCoref->setVisible(false);
    ui->RunRelation->setVisible(false);
    ui->textPathIn->setDisabled(true);
    ui->textPathOut->setDisabled(true);

    QDir dir(QCoreApplication::applicationDirPath());
    #if defined(Q_OS_WIN)
    if (dir.dirName().toLower() == "debug" ||
        dir.dirName().toLower() == "release")
    {
        dir.cdUp();
    }
    #elif defined(Q_OS_MAC)
    if (dir.dirName() == "MacOS")
    {
        dir.cdUp();
        dir.cdUp();
        dir.cdUp();
    }
    #endif
    QDir::setCurrent(dir.absolutePath());

}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_RunCoref_clicked()
{
    QString savedDir = QDir::currentPath();
    QDir path(pathInParental);
    path.mkpath("ReVerb_results");
    path = pathInParental + "/StanfordNLP_results";
    //QStringList list = path.entryList(QDir::Files);

    QProcess p;

    // 1. Run coreference.pl on the data + Stanford NLP processing results
    p.setStandardOutputFile(pathInParental + "/temp/aggregatedData.txt", QIODevice::Truncate);
    p.start("perl", QStringList() << "coreference.pl" << pathIn << path.currentPath());

    if (!p.waitForFinished(-1)){}

    // 2. Run reverb to extract sentence structures from the produced file
    p.setStandardOutputFile("res.txt", QIODevice::Truncate);
    p.start("java", QStringList() << "-Xmx512m" << "-jar" << "reverb/reverb-latest.jar" << "test.txt");

    // Is needed to wait for the process to finish
    if (!p.waitForFinished(-1)){}

    path = savedDir;

    ui->RunRelation->setVisible(true);
    ui->statusBar->showMessage("Coreferences resolved finished.");
}

void MainWindow::on_BrowseIn_clicked()
{
    pathIn = QFileDialog::getExistingDirectory (this, tr("Directory"), directory.path());

    if (!pathIn.isNull())
    {
        statusBar()->showMessage("Input folder selected.");
        ui->textPathIn->setText(pathIn);

        for (int i = 0; i < pathIn.split("/").length() - 1; i++)
            pathInParental.append(pathIn.split("/").value(i) + "/");

        pathInParental.chop(1);
    }
    else
        statusBar()->showMessage("Unable to locate input folder.");
}

void MainWindow::on_BrowseOut_clicked()
{
    pathOut = QFileDialog::getExistingDirectory (this, tr("Directory"), directory.path());

    if (!pathOut.isNull())
    {
        statusBar()->showMessage("Output folder selected. Please proceed with processing.");
        ui->textPathOut->setText(pathOut);
    }
    else
        statusBar()->showMessage("Unable to locate output folder.");

    ui->RunStanford->setVisible(true);
}

void MainWindow::on_RunStanford_clicked()
{
    //qDebug(QDir::currentPath().toLatin1());
    QDir::setCurrent("release");
    QString savedDir = QDir::currentPath();
    QDir::setCurrent(QDir::rootPath());
    QDir::setCurrent(pathInParental);

    QDir path(pathInParental);
    path.mkpath("temp");
    QString path2temp = pathInParental + "/temp";
    path.mkpath("StanfordNLP_results");
    QString path2parsed = pathInParental + "/StanfordNLP_results";
    path = pathIn;

    QString name = path2temp + "/listOfInput.txt";

    ofstream myfile;
    myfile.open(name.toLatin1().data(), ios::trunc);

    if (myfile.is_open())
    {
        QStringList list = path.entryList(QDir::Files);

        for (int i = 0; i < list.size(); i++)
            myfile << path2temp.toLatin1().data() << "/" <<list[i].toLatin1().data() << "\n";
    }
    else
        statusBar()->showMessage("Some files cannot be written.");

    QDir::setCurrent(savedDir);
    QDir::setCurrent("stanford-corenlp-full-2014-01-04");

    //QProcess p;
    //QString program = "java -cp stanford-corenlp-3.3.1.jar;stanford-corenlp-3.3.1-models.jar;xom.jar;joda-time.jar;jollyday.jar;ejml-0.23.jar -Xmx1g edu.stanford.nlp.pipeline.StanfordCoreNLP -annotators tokenize,ssplit,pos,lemma,ner,parse,dcoref -filelist " + name + " -outputDirectory " + pathInParental + "/StanfordNLP_results";
    //p.execute(program);

    QDir::setCurrent(savedDir);

    ui->RunCoref->setVisible(true);
    ui->statusBar->showMessage("Stanford NLP finished.");
}
