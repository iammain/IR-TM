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

    ui->RunStanford->setDisabled(true);
    ui->RunCoref->setDisabled(true);
    ui->RunRelation->setDisabled(true);
    ui->RunNormalization->setDisabled(true);
    ui->RunGDF->setDisabled(true);
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
//    QString savedDir = QDir::currentPath();
//    QDir path(pathInParental);
//    path.mkpath("ReVerb_results");
//    path = pathInParental + "/StanfordNLP_results";

//    QProcess p;

//    // 1. Run coreference.pl on the data + Stanford NLP processing results
//    p.setStandardOutputFile(pathInParental + "/temp/aggregatedData.txt", QIODevice::Truncate);
//    p.start("perl", QStringList() << "coreference.pl" << pathIn << path.absolutePath() << pathInParental + "/temp/aggregatedData.txt");

//    if (!p.waitForFinished(-1)){}

//    /////

//    // 2. Run reverb to extract sentence structures from the produced file
//    p.setStandardOutputFile(pathInParental + "/ReVerb_results/finalUberfilePre.txt", QIODevice::Truncate);
//    p.start("java", QStringList() << "-Xmx512m" << "-jar" << "reverb/reverb-latest.jar" << pathInParental + "/temp/aggregatedData.txt");

//    // Is needed to wait for the process to finish
//    if (!p.waitForFinished(-1)){}

//    /////

//    // 3. Replace tabs with newlines
//    QFile filepre(pathInParental + "/ReVerb_results/finalUberfilePre.txt");
//    QFile filepost(pathInParental + "/ReVerb_results/finalUberfilePost.txt");

//    filepre.open(QIODevice::ReadOnly | QIODevice::Text);
//    filepost.open(QIODevice::WriteOnly | QIODevice::Text);

//    QTextStream in(&filepre);
//    QTextStream out(&filepost);
//    QString line = in.readLine();

//    while (!line.isNull())
//    {
//        QStringList strs = line.split("\t");

//        for (int i = 0; i < strs.length(); i++)
//            if (i == 0)
//            {
//                QStringList substrs = strs[i].split(" ");

//                for (int j = 0; j < substrs.length(); j++)
//                    out << substrs[j] << "\n";
//            }
//            else
//            {
//                out << strs[i] << "\n";
//            }

//        line = in.readLine();
//    }

//    filepre.close();
//    filepost.close();

//    filepre.remove();
//    QFile::rename(pathInParental + "/ReVerb_results/finalUberfilePost.txt", pathInParental + "/ReVerb_results/finalUberfile.txt");
//    /////

//    path = savedDir;

    ui->RunRelation->setDisabled(false);
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

    ui->RunStanford->setDisabled(false);
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

//    QProcess p;
//    QString program = "java -cp stanford-corenlp-3.3.1.jar;stanford-corenlp-3.3.1-models.jar;xom.jar;joda-time.jar;jollyday.jar;ejml-0.23.jar -Xmx1g edu.stanford.nlp.pipeline.StanfordCoreNLP -annotators tokenize,ssplit,pos,lemma,ner,parse,dcoref -filelist " + name + " -outputDirectory " + pathInParental + "/StanfordNLP_results";
//    p.execute(program);

    QDir::setCurrent(savedDir);

    ui->RunCoref->setDisabled(false);
    ui->statusBar->showMessage("Stanford NLP finished.");
}

void MainWindow::on_RunRelation_clicked()
{
//    QProcess p;

//    p.setStandardOutputFile(pathOut + "/relations.csv", QIODevice::Truncate);
//    p.start("perl", QStringList() << "tokenextractor.pl" << pathInParental + "/ReVerb_results/finalUberfile.txt");

//    if (!p.waitForFinished(-1)){}

    ui->statusBar->showMessage("Relation extraction finished.");
    ui->RunNormalization->setDisabled(false);
}

void MainWindow::on_RunNormalization_clicked()
{
//    QProcess p;

//    p.setStandardOutputFile(pathOut + "/relationsNormalized.csv", QIODevice::Truncate);

//    //TODO dictionaries should be generated automatically
//    p.start("perl", QStringList() << "filterDB.pl" << pathOut + "/relations.csv" << "dictionaries");

//    if (!p.waitForFinished(-1)){}

    ui->statusBar->showMessage("Normalization finished.");
    ui->RunGDF->setDisabled(false);
}

void MainWindow::on_RunGDF_clicked()
{
    //TODO nodes file should be generated automatically
    QFile fileNodes("dictionaries/nodes.csv");
    QFile fileEdges(pathOut + "/relationsNormalized.csv");
    QFile fileRelations(pathOut + "/relations.gdf");

    fileNodes.open(QIODevice::ReadOnly | QIODevice::Text);
    fileEdges.open(QIODevice::ReadOnly | QIODevice::Text);
    fileRelations.open(QIODevice::WriteOnly | QIODevice::Text);


    QTextStream inNodes(&fileNodes);
    QTextStream inEdges(&fileEdges);
    QTextStream out(&fileRelations);
    QString line = inNodes.readLine();

    out << "nodedef> name VARCHAR,label VARCHAR, ppavm VARCHAR\n";

    while (!line.isNull())
    {
        out << line << "\n";
        line = inNodes.readLine();
    }

    line = inEdges.readLine();

    out << "edgedef> node1 VARCHAR,node2 VARCHAR,label VARCHAR\n";

    while (!line.isNull())
    {
        out << line << "\n";
        line = inEdges.readLine();
    }

    fileNodes.close();
    fileEdges.close();
    fileRelations.close();

    ui->statusBar->showMessage("Convertion to GDF finished.");
}
