"use client"

import { useState, useEffect } from "react"
import { motion } from "framer-motion"
import { Leaf, BarChart, Globe, Users, ArrowRight } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import Link from "next/link"

interface Footprint {
  id: number;
  name: string;
  location: string;
  footprint: number;
  color: string;
}

export default function LandingPage() {
  const [footprints, setFootprints] = useState<Footprint[]>([])

  // Generate random footprint data on component mount
  useEffect(() => {
    const generateFootprints = () => {
      const newFootprints = []
      const names = ["Alex", "Jamie", "Taylor", "Jordan", "Casey", "Morgan", "Riley", "Quinn", "Sam", "Avery"]
      const locations = ["New York", "London", "Tokyo", "Paris", "Sydney", "Berlin", "Toronto", "Singapore"]

      for (let i = 0; i < 20; i++) {
        newFootprints.push({
          id: i,
          name: names[Math.floor(Math.random() * names.length)],
          location: locations[Math.floor(Math.random() * locations.length)],
          footprint: Math.floor(Math.random() * 15) + 2, // Carbon footprint in tons (2-16)
          color: `hsl(${Math.floor(Math.random() * 60) + 100}, ${Math.floor(Math.random() * 30) + 60}%, ${Math.floor(Math.random() * 20) + 40}%)`,
        })
      }

      setFootprints(newFootprints)
    }

    generateFootprints()
  }, [])

  return (
    <div className="flex flex-col min-h-screen">
      <header className="border-b">
        <div className="container flex h-16 items-center justify-between px-4 md:px-6">
          <Link href="/" className="flex items-center gap-2">
            <Leaf className="h-6 w-6 text-green-600" />
            <span className="text-xl font-bold">EcoPulse</span>
          </Link>
          <nav className="hidden md:flex gap-6">
            <Link href="#features" className="text-sm font-medium hover:underline underline-offset-4">
              Features
            </Link>
            <Link href="#how-it-works" className="text-sm font-medium hover:underline underline-offset-4">
              How It Works
            </Link>
            <Link href="#about" className="text-sm font-medium hover:underline underline-offset-4">
              About
            </Link>
            <Link href="#contact" className="text-sm font-medium hover:underline underline-offset-4">
              Contact
            </Link>
          </nav>
        </div>
      </header>

      <main className="flex-1">
        {/* Hero Section */}
        <section className="w-full py-12 md:py-24 lg:py-32 bg-gradient-to-b from-green-50 to-white dark:from-green-950 dark:to-background">
          <div className="container px-4 md:px-6">
            <div className="grid gap-6 lg:grid-cols-2 lg:gap-12 items-center">
              <div className="space-y-4">
                <h1 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl">
                  Measure Your Carbon Footprint, Make a Difference
                </h1>
                <p className="max-w-[600px] text-muted-foreground md:text-xl">
                  Join thousands of people tracking and reducing their carbon footprint. Small changes add up to big
                  impact.
                </p>
                <div className="flex flex-col gap-2 min-[400px]:flex-row">
                  <Link href="/calculator" passHref>
                    <Button className="bg-green-600 hover:bg-green-700">Calculate Your Footprint</Button>
                  </Link>
                  <Button variant="outline">Learn More</Button>
                </div>
              </div>
              <div className="relative h-[400px] w-full overflow-hidden rounded-xl border bg-gradient-to-b from-green-100 to-white dark:from-green-900 dark:to-background p-4">
                <div className="absolute inset-0">
                  {footprints.map((footprint) => (
                    <FootprintBox key={footprint.id} footprint={footprint} />
                  ))}
                </div>
                <div className="absolute bottom-4 left-4 right-4 bg-white/80 dark:bg-black/80 backdrop-blur-sm p-4 rounded-lg">
                  <h3 className="font-medium">Real-time Carbon Footprints</h3>
                  <p className="text-sm text-muted-foreground">
                    See how your footprint compares to others around the world
                  </p>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Features Section */}
        <section id="features" className="w-full py-12 md:py-24 lg:py-32">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center justify-center space-y-4 text-center">
              <div className="space-y-2">
                <div className="inline-block rounded-lg bg-green-100 dark:bg-green-800 px-3 py-1 text-sm">Features</div>
                <h2 className="text-3xl font-bold tracking-tighter md:text-4xl">
                  Everything you need to track your carbon footprint
                </h2>
                <p className="max-w-[700px] text-muted-foreground md:text-xl">
                  Our comprehensive tools help you understand, track, and reduce your environmental impact.
                </p>
              </div>
            </div>
            <div className="mx-auto grid max-w-5xl grid-cols-1 gap-6 py-12 md:grid-cols-2 lg:grid-cols-3">
              <div className="flex flex-col items-center space-y-2 rounded-lg border p-6 shadow-sm">
                <div className="rounded-full bg-green-100 dark:bg-green-800 p-3">
                  <BarChart className="h-6 w-6 text-green-600 dark:text-green-400" />
                </div>
                <h3 className="text-xl font-bold">Detailed Analytics</h3>
                <p className="text-center text-muted-foreground">
                  Get insights into your carbon footprint with detailed breakdowns and comparisons.
                </p>
              </div>
              <div className="flex flex-col items-center space-y-2 rounded-lg border p-6 shadow-sm">
                <div className="rounded-full bg-green-100 dark:bg-green-800 p-3">
                  <Globe className="h-6 w-6 text-green-600 dark:text-green-400" />
                </div>
                <h3 className="text-xl font-bold">Global Comparison</h3>
                <p className="text-center text-muted-foreground">
                  See how your footprint compares to global and regional averages.
                </p>
              </div>
              <div className="flex flex-col items-center space-y-2 rounded-lg border p-6 shadow-sm">
                <div className="rounded-full bg-green-100 dark:bg-green-800 p-3">
                  <Users className="h-6 w-6 text-green-600 dark:text-green-400" />
                </div>
                <h3 className="text-xl font-bold">Community Impact</h3>
                <p className="text-center text-muted-foreground">
                  Join a community of environmentally conscious individuals making a difference.
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* How It Works Section */}
        <section id="how-it-works" className="w-full py-12 md:py-24 lg:py-32 bg-green-50 dark:bg-green-950">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center justify-center space-y-4 text-center">
              <div className="space-y-2">
                <div className="inline-block rounded-lg bg-green-100 dark:bg-green-800 px-3 py-1 text-sm">
                  How It Works
                </div>
                <h2 className="text-3xl font-bold tracking-tighter md:text-4xl">Calculate, Compare, Reduce</h2>
                <p className="max-w-[700px] text-muted-foreground md:text-xl">
                  Our simple 3-step process helps you understand and reduce your carbon footprint.
                </p>
              </div>
            </div>
            <div className="mx-auto grid max-w-5xl grid-cols-1 gap-6 py-12 md:grid-cols-3">
              <div className="relative flex flex-col items-center space-y-2 p-6">
                <div className="absolute -top-4 left-1/2 -translate-x-1/2 rounded-full bg-green-600 px-4 py-1 text-sm font-bold text-white">
                  Step 1
                </div>
                <h3 className="pt-4 text-xl font-bold">Calculate</h3>
                <p className="text-center text-muted-foreground">
                  Answer a few questions about your lifestyle, transportation, and energy usage.
                </p>
              </div>
              <div className="relative flex flex-col items-center space-y-2 p-6">
                <div className="absolute -top-4 left-1/2 -translate-x-1/2 rounded-full bg-green-600 px-4 py-1 text-sm font-bold text-white">
                  Step 2
                </div>
                <h3 className="pt-4 text-xl font-bold">Compare</h3>
                <p className="text-center text-muted-foreground">
                  See how your footprint compares to others and identify areas for improvement.
                </p>
              </div>
              <div className="relative flex flex-col items-center space-y-2 p-6">
                <div className="absolute -top-4 left-1/2 -translate-x-1/2 rounded-full bg-green-600 px-4 py-1 text-sm font-bold text-white">
                  Step 3
                </div>
                <h3 className="pt-4 text-xl font-bold">Reduce</h3>
                <p className="text-center text-muted-foreground">
                  Get personalized recommendations to reduce your carbon footprint over time.
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* CTA Section */}
        <section className="w-full py-12 md:py-24 lg:py-32">
          <div className="container px-4 md:px-6">
            <div className="flex flex-col items-center justify-center space-y-4 text-center">
              <div className="space-y-2">
                <h2 className="text-3xl font-bold tracking-tighter md:text-4xl">Ready to make a difference?</h2>
                <p className="max-w-[700px] text-muted-foreground md:text-xl">
                  Join thousands of people who are tracking and reducing their carbon footprint.
                </p>
              </div>
              <div className="w-full max-w-sm space-y-2">
                <div className="flex flex-col gap-2 min-[400px]:flex-row">
                  <Input type="email" placeholder="Enter your email" />
                  <Button className="bg-green-600 hover:bg-green-700">
                    Get Started <ArrowRight className="ml-2 h-4 w-4" />
                  </Button>
                </div>
                <p className="text-xs text-muted-foreground">
                  By signing up, you agree to our{" "}
                  <Link href="#" className="underline underline-offset-2">
                    Terms & Conditions
                  </Link>
                </p>
              </div>
            </div>
          </div>
        </section>
      </main>

      <footer className="border-t bg-green-50 dark:bg-green-950">
        <div className="container flex flex-col gap-4 py-10 md:flex-row md:gap-8 px-4 md:px-6">
          <div className="flex flex-col gap-2 md:gap-4 md:w-1/3">
            <Link href="/" className="flex items-center gap-2">
              <Leaf className="h-6 w-6 text-green-600" />
              <span className="text-xl font-bold">CarbonCalc</span>
            </Link>
            <p className="text-sm text-muted-foreground">
              Helping individuals and businesses measure, understand, and reduce their carbon footprint.
            </p>
          </div>
          <div className="grid flex-1 grid-cols-2 gap-8 sm:grid-cols-3">
            <div className="flex flex-col gap-2">
              <h3 className="text-sm font-medium">Product</h3>
              <nav className="flex flex-col gap-2">
                <Link href="#" className="text-sm hover:underline">
                  Features
                </Link>
                <Link href="#" className="text-sm hover:underline">
                  Pricing
                </Link>
                <Link href="#" className="text-sm hover:underline">
                  For Teams
                </Link>
                <Link href="#" className="text-sm hover:underline">
                  For Business
                </Link>
              </nav>
            </div>
            <div className="flex flex-col gap-2">
              <h3 className="text-sm font-medium">Resources</h3>
              <nav className="flex flex-col gap-2">
                <Link href="#" className="text-sm hover:underline">
                  Blog
                </Link>
                <Link href="#" className="text-sm hover:underline">
                  Documentation
                </Link>
                <Link href="#" className="text-sm hover:underline">
                  Guides
                </Link>
                <Link href="#" className="text-sm hover:underline">
                  Support
                </Link>
              </nav>
            </div>
            <div className="flex flex-col gap-2">
              <h3 className="text-sm font-medium">Company</h3>
              <nav className="flex flex-col gap-2">
                <Link href="#" className="text-sm hover:underline">
                  About
                </Link>
                <Link href="#" className="text-sm hover:underline">
                  Careers
                </Link>
                <Link href="#" className="text-sm hover:underline">
                  Contact
                </Link>
                <Link href="#" className="text-sm hover:underline">
                  Privacy
                </Link>
              </nav>
            </div>
          </div>
        </div>
        <div className="border-t py-6">
          <div className="container flex flex-col items-center justify-between gap-4 md:flex-row px-4 md:px-6">
            <p className="text-xs text-muted-foreground">
              © {new Date().getFullYear()} CarbonCalc. All rights reserved.
            </p>
            <div className="flex gap-4">
              <Link href="#" className="text-xs text-muted-foreground hover:underline">
                Privacy Policy
              </Link>
              <Link href="#" className="text-xs text-muted-foreground hover:underline">
                Terms of Service
              </Link>
              <Link href="#" className="text-xs text-muted-foreground hover:underline">
                Cookie Policy
              </Link>
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}

// Animated footprint box component
function FootprintBox({ footprint }: { footprint: Footprint }) {
  // Generate random position and animation properties
  const x = Math.random() * 100
  const y = Math.random() * 100
  const size = footprint.footprint * 6 // Scale the size based on footprint value

  // Animation variants for the floating effect
  const floatingAnimation = {
    initial: { x: `${x}%`, y: `${y}%`, opacity: 0, scale: 0 },
    animate: {
      opacity: 0.9,
      scale: 1,
      transition: {
        duration: 0.5,
        delay: Math.random() * 0.5,
      },
    },
    float: {
      y: [`${y}%`, `${y - 5}%`, `${y}%`, `${y + 5}%`, `${y}%`],
      x: [`${x}%`, `${x + 3}%`, `${x}%`, `${x - 3}%`, `${x}%`],
      transition: {
        y: {
          duration: 5 + Math.random() * 2,
          repeat: Number.POSITIVE_INFINITY,
          ease: "easeInOut",
        },
        x: {
          duration: 6 + Math.random() * 3,
          repeat: Number.POSITIVE_INFINITY,
          ease: "easeInOut",
        },
      },
    },
  }

  return (
    <motion.div
      className="absolute rounded-lg shadow-md flex flex-col justify-center items-center text-white text-xs font-medium overflow-hidden"
      style={{
        backgroundColor: footprint.color,
        width: `${size}px`,
        height: `${size}px`,
        transform: `translate(-50%, -50%)`,
      }}
      initial="initial"
      animate={["animate", "float"]}
      variants={floatingAnimation}
    >
      <span className="text-center px-1">{footprint.footprint}t</span>
      <span className="text-center text-[8px] opacity-80">{footprint.name}</span>
    </motion.div>
  )
}

