interface WeatherDataSubject {
    void register(WeatherDataObserver w);
    void remove(WeatherDataObserver w);
    void notifyDisplays();
}
