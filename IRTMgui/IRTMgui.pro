#-------------------------------------------------
#
# Project created by QtCreator 2014-05-29T12:13:05
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = IRTMgui
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp

HEADERS  += mainwindow.h

FORMS    += mainwindow.ui

OTHER_FILES += \
    ../Extraction/Scripts/coreference.pl \
    ../Extraction/Scripts/filterDB.pl \
    ../Extraction/Scripts/tokenExtractor.pl
