/*
 * AbstractTestCase.vala
 *
 * The Log4Vala Project
 *
 * Copyright 2013-2016 Sensical, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

public abstract class AbstractTestCase : Object {

    private GLib.TestSuite suite;
    private Adaptor[] adaptors = new Adaptor[0];

    public delegate void TestMethod ();

    protected AbstractTestCase (string name) {
        this.suite = new GLib.TestSuite (name);
    }

    public void add_test (string name, owned TestMethod test) {
        var adaptor = new Adaptor (name, (owned) test, this);
        this.adaptors += adaptor;

        this.suite.add (
            new GLib.TestCase (adaptor.name, adaptor.set_up, adaptor.run, adaptor.tear_down)
        );
    }

    public virtual void set_up () {
    }

    public virtual void tear_down () {
    }

    public GLib.TestSuite get_suite () {
        return this.suite;
    }

    private class Adaptor {
        public string name { get; private set; }
        private TestMethod test;
        private AbstractTestCase test_case;

        public Adaptor (string name, owned TestMethod test, AbstractTestCase test_case) {
            this.name = name;
            this.test = (owned) test;
            this.test_case = test_case;
        }

        public void set_up (void * fixture) {
            this.test_case.set_up ();
        }

        public void run (void * fixture) {
            this.test ();
        }

        public void tear_down (void * fixture) {
            this.test_case.tear_down ();
        }
    }
}