class BodyChange(object):
    def __init__(self, df, dl, dg, dDecw, dtherm):
        self.df = df or 0
        self.dl = dl or 0
        self.dg = dg or 0
        self.dDecw = dDecw or 0
        self.dtherm = dtherm or 0