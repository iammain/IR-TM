#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QFileDialog>
#include <QtCore>
#include <QtGui>
#include <QDialog>
#include <time.h>
#include <QGraphicsScene>
#include <QGraphicsTextItem>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void on_RunCoref_clicked();

    void on_BrowseIn_clicked();

    void on_BrowseOut_clicked();

    void on_RunStanford_clicked();

private:
    Ui::MainWindow *ui;
    QDir directory;
    QString pathIn;
    QString pathInParental;
    QString pathOut;

};

#endif // MAINWINDOW_H
